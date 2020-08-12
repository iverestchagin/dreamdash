#include "can.h"
#include <QCanBus>
#include <QCanBusFrame>
#include <QVariant>
#include <QDebug>
#include <QtMath>
#include <QTimer>
#include <QSettings>
#include <QThread>

Can::Can(QObject *parent) : QObject(parent)
{
	connectDevice();
	mmapGpio* rpiGpio = mmapGpio::getInstance();

	rpiGpio->setPinDir(REAR_CAM_GPIO, mmapGpio::OUTPUT);
	rpiGpio->writePinState(REAR_CAM_GPIO, 1);

	rpiGpio->setPinDir(LEFT_LED_GPIO, mmapGpio::OUTPUT);
	rpiGpio->writePinLow(LEFT_LED_GPIO);
	rpiGpio->setPinDir(RIGHT_LED_GPIO, mmapGpio::OUTPUT);
	rpiGpio->writePinLow(RIGHT_LED_GPIO);

	rearCameraTimerOn = new QTimer(this);
	rearCameraTimerOn->setSingleShot(true);
	connect(rearCameraTimerOn, SIGNAL(timeout()), this, SLOT(rearCameraOn()));

	rearCameraTimerOff = new QTimer(this);
	rearCameraTimerOff->setSingleShot(true);
	connect(rearCameraTimerOff, SIGNAL(timeout()), this, SLOT(rearCameraOff()));

	can1Timer = new QTimer(this);
	can1Timer->setSingleShot(false);
	connect(can1Timer, SIGNAL(timeout()), this, SLOT(can1Tick()));
	can1Timer->start(1000);

	tempTimer = new QTimer(this);
	tempTimer->setSingleShot(false);
	connect(tempTimer, SIGNAL(timeout()), this, SLOT(tempTick()));
	tempTimer->start(3000);

	m_turn_volume = settings.value("turn_volume").toReal();
	m_turn_sound = settings.value("turn_sound").toBool();
	m_camera = settings.value("camera").toBool();
	m_gas_sensor = settings.value("gas_sensor").toBool();

	turnOnSound.setSource(QUrl("qrc:/view/base/sound/turn_on.wav"));
	turnOnSound.setVolume(m_turn_volume);

	turnOffSound.setSource(QUrl("qrc:/view/base/sound/turn_off.wav"));
	turnOffSound.setVolume(m_turn_volume);

	QObject::connect(this, &Can::turnVolumeChanged, this, [=](qreal value){
		turnOnSound.setVolume(value);
		turnOffSound.setVolume(value);
		settings.setValue("turn_volume", value);
	});

	QObject::connect(this, &Can::turnSoundChanged, this, [=](bool value){
		m_turn_sound = value;
		settings.setValue("turn_sound", value);
	});

	QObject::connect(this, &Can::cameraChanged, this, [=](bool value){
		m_camera = value;
		settings.setValue("camera", value);
	});

	QObject::connect(this, &Can::gasSensorChanged, this, [=](bool value){
		m_gas_sensor = value;
		settings.setValue("gas_sensor", value);
	});

	QObject::connect(this, &Can::leftTurnChanged, this, [=](bool value){
		rpiGpio->writePinState(LEFT_LED_GPIO, value ? 1 : 0);
	});

	QObject::connect(this, &Can::rightTurnChanged, this, [=](bool value){
		rpiGpio->writePinState(RIGHT_LED_GPIO, value ? 1 : 0);
	});

	QObject::connect(this, &Can::gearChanged, this, [=](QString gear){
		if(m_camera) {
			if(gear == "R") {
				this->rearCameraTimerOff->stop();
				this->rearCameraTimerOn->start(1500);
			}
			else {
				this->rearCameraTimerOn->stop();
				this->rearCameraTimerOff->start(1000);
			}
		}
	});

	QObject::connect(this, &Can::turnChanged, this, [=](bool value) {
		if(m_turn_sound) {
			if(value) {
				turnOnSound.play();
			}
			else {
				turnOffSound.play();
			}
		}
		else if(m_can0 != nullptr) {
			if(value) {
				m_can0->writeFrame(QCanBusFrame(0x10400060, QByteArrayLiteral("\x82\x08\x01\xFF\xD4")));
			}
			else {
				m_can0->writeFrame(QCanBusFrame(0x10400060, QByteArrayLiteral("\x81\x08\x01\xFF\xD5")));
			}
		}
	});

	QObject::connect(this, &Can::fuelChanged, this, [=]() {
		if(m_odo > 0) {
			if(m_odo_fuel.size() == 0 || m_odo_fuel.back().second > m_fuel) {
				m_odo_fuel.push(std::pair<quint32, quint8>(m_odo, m_fuel));
			}
			else if(m_odo_fuel.size() > 0 && ((m_fuel - m_odo_fuel.front().second) > 20)) {
				while(m_odo_fuel.size() > 0) {
					m_odo_fuel.pop();
				}
				m_odo_fuel.push(std::pair<quint32, quint8>(m_odo, m_fuel));
			}

			while(m_odo_fuel.size() > 20) {
				m_odo_fuel.pop();
			}
			if(m_odo_fuel.size() > 2) {
				double fuel = m_odo_fuel.front().second - m_odo_fuel.back().second;
				double distance = m_odo_fuel.back().first - m_odo_fuel.front().first;
				if(distance > 0) {
					quint16 rate = quint16(((fuel * (45.0 / 255.0)) / (distance / 100.0)) * 10000);
					if(rate > 2000) {
						if(m_odo_fuel.size() > 1) {
							m_odo_fuel.pop();
						}
					}
					else {
						if(m_fuel_rate != rate) {
							m_fuel_rate = rate;
							emit fuelRateChanged(m_fuel_rate);
						}
					}
				}
			}
		}
	});
}

void Can::connectDevice() {
	QString errorString = "";
	m_can0 = QCanBus::instance()->createDevice("socketcan", "can0", &errorString);
	if (!m_can0) {
		qCritical("Error creating device, reason: '%s'", errorString.toStdString().c_str());
		return;
	}
	connect(m_can0, &QCanBusDevice::framesReceived, this, &Can::processReceivedFrames);
	if (!m_can0->connectDevice()) {
		qCritical("Connection error: '%s'", m_can0->errorString().toStdString().c_str());
		delete m_can0;
		m_can0 = nullptr;
	}

	m_can0->writeFrame(QCanBusFrame(0x627, QByteArrayLiteral("\x01\x40\x00\x00\x00\x00\x00\x00")));

	errorString = "";
	m_can1 = QCanBus::instance()->createDevice("socketcan", "can1", &errorString);
	if (!m_can1) {
		qCritical("Error creating device, reason: '%s'", errorString.toStdString().c_str());
		return;
	}
	connect(m_can1, &QCanBusDevice::framesReceived, this, &Can::processReceivedFrames);
	if (!m_can1->connectDevice()) {
		qCritical("Connection error: '%s'", m_can1->errorString().toStdString().c_str());
		delete m_can1;
		m_can1 = nullptr;
	}
}

void Can::processReceivedFrames()
{
	if (m_can0) {
		while (m_can0->framesAvailable()) {
			const QCanBusFrame frame = m_can0->readFrame();

			QByteArray payload = frame.payload();
			int size = payload.size();

			switch(frame.frameId()) {
			case 0x10210040: //speed
				if(size >= 2) {
					//quint16 speed = double(((quint8)payload[0] << 8) + ((quint8)payload[1])) / 61;
					quint16 speed = quint16(double((quint8(payload[0]) << 8) + quint8(payload[1])) / 61);
					if(m_speed != speed) {
						m_speed = speed;
						emit speedChanged(speed);
					}
				}
				break;
			case 0x106C0040: //odo
				if (size >= 5) {
					quint32 odo =
							quint32(payload[0] * qPow(2, 18) * 100) +
							quint32(payload[1] * qPow(2, 10) * 100) +
							quint32(payload[2] * qPow(2, 2) * 100) +
							quint32(payload[3]);

					if (m_odo != odo) {
						m_odo = odo;
						emit odoChanged(odo);
					}
				}
				break;
			case 0x102CA040: //rpm and gear
				if(size >= 8) {
					quint16 rpm = quint16(double((payload[2] << 8) + payload[3]) / 3.8);
					if (m_rpm != rpm) {
						m_rpm = rpm;
						emit rpmChanged(rpm);
					}

					quint8 gearInt = payload[6] & 0xF;
					QString gear = "";

					switch (gearInt) {
					case 1:
						gear = "P";
						break;
					case 2:
						gear = "R";
						break;
					case 3:
						gear = "N";
						break;
					case 4:
						gear = "D";
						break;
					case 5:
						gear = "M";
					}

					if (m_gear != gear) {
						m_gear = gear;
						emit gearChanged(gear);
					}
				}
				break;
			case 0x102CE040: //gear num
				if(size > 2) {
					quint8 gearNum = quint8(payload[1] >> 3);

					if(m_gear_num != gearNum) {
						m_gear_num = gearNum;
						emit gearNumChanged(gearNum);
					}
				}
				break;
			case 0x10800040: //fuel
				if (size >= 2) {
					quint8 fuel = quint8(payload[1]);
					if (m_fuel != fuel) {
						m_fuel = fuel;
						emit fuelChanged(fuel);
					}
				}
				break;
			case 0x1020C040: //lights
				processLights(payload);
				break;
			case 0x0C630040: //door, left, front, 2019
			case 0x10630040: //door, left, front
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_door_fl != val) {
						m_door_fl = val;
						qDebug() << "m_door_fl" << m_door_fl;
						emit doorFLChanged(m_door_fl);
					}
				}
				break;
			case 0x0C2F6040: //door, right, front, 2019
			case 0x102F6040: //door, right, front
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_door_fr != val) {
						m_door_fr = val;
						qDebug() << "m_door_fr" << m_door_fr;
						emit doorFRChanged(m_door_fr);
					}
				}
				break;
			case 0x0C2F8040: //door, left, back, 2019
			case 0x102F8040: //door, left, back
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_door_bl != val) {
						m_door_bl = val;
						qDebug() << "m_door_bl" << m_door_bl;
						emit doorBLChanged(m_door_bl);
					}
				}
				break;
			case 0x0C2FA040: //door, right, back, 2019
			case 0x102FA040: //door, right, back
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_door_br != val) {
						m_door_br = val;
						qDebug() << "m_door_br" << m_door_br;
						emit doorBRChanged(m_door_br);
					}
				}
				break;
			case 0x0C6AA040: //trunk, 2019
			case 0x106AA040: //trunk
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_trunk != val) {
						m_trunk = val;
						qDebug() << "m_trunk" << m_trunk;
						emit trunkChanged(m_trunk);
					}
				}
				break;
			case 0x10264040: //abs
				if(size >= 1) {
					bool val = bool(payload[0] & 1);
					if(m_abs != val) {
						m_abs = val;
						qDebug() << "m_abs" << m_abs;
						emit absChanged(m_abs);
					}
				}
				break;
//            case 0x102CC040: //battery
//                if(size >= 1) {
//                    if(m_battery_check != bool(payload[0])) {
//                        m_battery_check = bool(payload[0]);
//                        emit batteryCheckChanged(m_battery_check);
//                    }
//                }
//                break;
			case 0x10336058: //seatbelt
				if(size >= 1) {
					if(m_seatbelt != !bool(payload[0])) {
						m_seatbelt = !bool(payload[0]);
						emit seatbeltChanged(m_seatbelt);
					}
				}
				break;
//			case 0x10424060: //outside temp
//				if(size >= 2) {
//					qint16 temp = (quint8(payload[1]) * 128 / 255) - 40;

//					if(m_outside_temp != temp) {
//						m_outside_temp = temp;
//						emit outsideTempChanged(m_outside_temp);
//					}
//				}
//				break;
			case 0x103B4040: //handbrake
				if(size >= 1) {
					if (m_handbrake != bool(payload[0] & (1 << 2))) {
						m_handbrake =  bool(payload[0] & (1 << 2));
						emit handbrakeChanged(m_handbrake);
					}
				}
				break;
			case 0x10632040: //error
				if(size >= 2) {
					const quint16 e = quint16((payload[0] << 8) + payload[1]);

					m_errors.clear();
					for(auto const& x : m_error_map) {
						if((e & x.first) == x.first) {
							m_errors.push_back(x.second);
						}
					}

					if(m_errors.size() > 0) {
						emit errorsChanged(m_errors);
					}
				}
				break;
			}
		}
	}
	if (m_can1) {
		while (m_can1->framesAvailable()) {
			const QCanBusFrame frame = m_can1->readFrame();

			QByteArray payload = frame.payload();
			int size = payload.size();

			switch(frame.frameId()) {
			case 0x4C1: //coolant temp
				if(size >= 3) {
					qint16 coolant_temp = qint16(payload[2]) - 40;
					//qDebug() << frame.frameId() << coolant_temp;
					if (m_coolant_temp != coolant_temp) {
						m_coolant_temp =  coolant_temp;
						emit coolantTempChanged(m_coolant_temp);
					}
				}
				break;
			case 0x7E8:
				 //payload[0] - is data size https://www.csselectronics.com/screen/page/obd-ii-pid-examples
				if(size > 2 && int(payload[1]) == 0x41) {
					switch (quint8(payload[2])) {
					case 0x01: //Monitor status since DTCs cleared and MIL (malfunction indicator lamp)
					{
						bool check = bool(payload[3] & (1 << 7));
						if(m_engine_check != check) {
							m_engine_check = check;
							emit engineCheckChanged(m_engine_check);
						}
					}
						break;
					case 0x10: //MAF https://ru.wikipedia.org/wiki/OBD-II_PIDs
					{
						//((A*256)+B) / 100 = grams/sec
						double maf = ((double(payload[3]) * 256.0) + double(payload[4])) / 100.0; //air g/s
						double flh = maf / 14.7 / 710 * 3600; //14.7 ideal air/fuel rate, 710 - fuel density in g/L, fuel L/h

						quint16 fuelLH = quint16(flh * 100);
						if(m_fuel_lh != fuelLH) {
							m_fuel_lh = fuelLH;
							emit fuelLHChanged(m_fuel_lh);
						}

						break;
					}
					case 0x46: //Ambient air temperature
					{
						qint16 temp = qint16(payload[3]) - 40;
						qDebug() << "temp" << temp;
						if(m_outside_temp != temp) {
							m_outside_temp = temp;
							emit outsideTempChanged(m_outside_temp);
						}
					}
						break;
//					case 0x5E: //Engine fuel rate
//					{
//						qint16 rate = qint16((256 * payload[3] + payload[4]) / 2);
//						qDebug() << "rate" << rate;
//						if(m_fuel_rate != rate) {
//							m_fuel_rate = rate;
//							emit fuelRateChanged(m_fuel_rate);
//						}
//					}
//						break;
					}
				}
				break;
			}
		}
	}
}

void Can::processLights(QByteArray payload) {
	int size = payload.size();

	if(size >= 4) {
		bool val;

		val = bool(payload[1] & (1 << 6));
		if (m_park_light != val) {
			m_park_light  = val;
			emit parkLightChanged(val);
		}

		val = bool(payload[1] & (1 << 5));
		if (m_high_beam != val) {
			m_high_beam  = val;
			emit highBeamChanged(val);
		}

		val = bool(payload[1] & (1 << 4));
		if (m_back_fog != val) {
			m_back_fog  = val;
			emit backFogChanged(val);
		}

		val = bool(payload[1] & (1 << 1));
		if (m_front_fog != val) {
			m_front_fog  = val;
			emit frontFogChanged(val);
		}

		val = (bool(payload[3] & (1 << 6)) && m_park_light);
		if (m_low_beam != val) {
			m_low_beam  = val;
			emit lowBeamChanged(val);
		}

		bool turn_changed = false;

		val = bool(payload[3] & (1 << 5));
		if (m_left_turn != val) {
			m_left_turn  = val;
			emit leftTurnChanged(val);
			turn_changed = true;
		}

		val = bool(payload[3] & (1 << 1));
		if (m_right_turn != val) {
			m_right_turn  = val;
			emit rightTurnChanged(val);
			turn_changed = true;
		}

		if(turn_changed) {
			emit turnChanged(m_left_turn || m_right_turn);
		}
	}
}

void Can::rearCameraOn() {
	qDebug("rearCameraOn");
	mmapGpio::getInstance()->writePinState(REAR_CAM_GPIO, 0);
	emit reverseOn();
}

void Can::rearCameraOff() {
	qDebug("rearCameraOff");
	mmapGpio::getInstance()->writePinState(REAR_CAM_GPIO, 1);
	emit reverseOff();
}

void Can::can1Tick() {
	if(m_can1) {
		if(!m_can1->writeFrame(QCanBusFrame(0x7DF, QByteArrayLiteral("\x02\x01\x01\x00\x00\x00\x00\x00")))) {
			qCritical("Can't send request for mil to can1");
		}
		QThread::msleep(10);
		if(!m_can1->writeFrame(QCanBusFrame(0x7DF, QByteArrayLiteral("\x02\x01\x10\x00\x00\x00\x00\x00")))) {
			qCritical("Can't send request for maf to can1");
		}
		QThread::msleep(10);
		if(!m_can1->writeFrame(QCanBusFrame(0x7DF, QByteArrayLiteral("\x02\x01\x46\x00\x00\x00\x00\x00")))) {
			qCritical("Can't send request for outside temp to can1");
		}
		QThread::msleep(10);
	}
}

void Can::tempTick() {
	if(m_can0) {
		QByteArray a = QByteArrayLiteral("\x00\x00\x00\x00\x00\x00\x00\x00");
		a[1] = char(double(m_outside_temp + 40) * 255.0 / 128.0);
		if(!m_can0->writeFrame(QCanBusFrame(0x10424060, a))) {
			qCritical("Can't send outside temp to can0");
		}
	}
}

void Can::screenOn() {
	can1Timer->start(1000);
	tempTimer->start(3000);
	if(m_can0) {
		m_can0->writeFrame(QCanBusFrame(0x627, QByteArrayLiteral("\x01\x40\x00\x00\x00\x00\x00\x00")));
	}
}

void Can::screenOff() {
	can1Timer->stop();
	tempTimer->stop();
}