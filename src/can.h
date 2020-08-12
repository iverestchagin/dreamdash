#ifndef CAN_H
#define CAN_H

#include <QCanBus>
#include <QObject>
#include <QTimer>
#include <QSettings>
#include <map>
#include <array>
#include <queue>
#include <set>
#include <QSoundEffect>
#include <mmapgpio.h>

class Can : public QObject
{
	Q_OBJECT
	Q_PROPERTY(quint16 speed MEMBER m_speed NOTIFY speedChanged)
	Q_PROPERTY(quint16 rpm MEMBER m_rpm NOTIFY rpmChanged)
	Q_PROPERTY(quint32 odo MEMBER m_odo NOTIFY odoChanged)
	Q_PROPERTY(quint8 fuel MEMBER m_fuel NOTIFY fuelChanged)
	Q_PROPERTY(quint8 gas MEMBER m_gas NOTIFY gasChanged)
	Q_PROPERTY(QString gear MEMBER m_gear NOTIFY gearChanged)
	Q_PROPERTY(quint8 gearNum MEMBER m_gear_num NOTIFY gearNumChanged)

	Q_PROPERTY(bool leftTurn MEMBER m_left_turn NOTIFY leftTurnChanged)
	Q_PROPERTY(bool rightTurn MEMBER m_right_turn NOTIFY rightTurnChanged)
	Q_PROPERTY(bool parkLight MEMBER m_park_light NOTIFY parkLightChanged)
	Q_PROPERTY(bool doorFL MEMBER m_door_fl NOTIFY doorFLChanged)
	Q_PROPERTY(bool doorFR MEMBER m_door_fr NOTIFY doorFRChanged)
	Q_PROPERTY(bool doorBL MEMBER m_door_bl NOTIFY doorBLChanged)
	Q_PROPERTY(bool doorBR MEMBER m_door_br NOTIFY doorBRChanged)
	Q_PROPERTY(bool trunk MEMBER m_trunk NOTIFY trunkChanged)
	Q_PROPERTY(bool carLock MEMBER m_car_lock NOTIFY carLockChanged)
	Q_PROPERTY(bool lowBeam MEMBER m_low_beam NOTIFY lowBeamChanged)
	Q_PROPERTY(bool highBeam MEMBER m_high_beam NOTIFY highBeamChanged)
	Q_PROPERTY(bool frontFog MEMBER m_front_fog NOTIFY frontFogChanged)
	Q_PROPERTY(bool backFog MEMBER m_back_fog NOTIFY backFogChanged)
	Q_PROPERTY(bool seatbelt MEMBER m_seatbelt NOTIFY seatbeltChanged)
	Q_PROPERTY(bool airbag MEMBER m_airbag NOTIFY airbagChanged)
	Q_PROPERTY(bool abs MEMBER m_abs NOTIFY absChanged)
	Q_PROPERTY(bool handbrake MEMBER m_handbrake NOTIFY handbrakeChanged)
	Q_PROPERTY(bool engineCheck MEMBER m_engine_check NOTIFY engineCheckChanged)
	Q_PROPERTY(bool batteryCheck MEMBER m_battery_check NOTIFY batteryCheckChanged)
	Q_PROPERTY(bool oilCheck MEMBER m_oil_check NOTIFY oilCheckChanged)

	Q_PROPERTY(qint16 outsideTemp MEMBER m_outside_temp NOTIFY outsideTempChanged)
	Q_PROPERTY(qint16 coolantTemp MEMBER m_coolant_temp NOTIFY coolantTempChanged)
	Q_PROPERTY(quint16 fuelLH MEMBER m_fuel_lh NOTIFY fuelLHChanged)
	Q_PROPERTY(quint16 fuelRate MEMBER m_fuel_rate NOTIFY fuelRateChanged)

	Q_PROPERTY(std::vector<int> errors MEMBER m_errors NOTIFY errorsChanged)

	Q_PROPERTY(bool turnSound MEMBER m_turn_sound NOTIFY turnSoundChanged)
	Q_PROPERTY(qreal turnVolume MEMBER m_turn_volume NOTIFY turnVolumeChanged)
	Q_PROPERTY(bool camera MEMBER m_camera NOTIFY cameraChanged)
	Q_PROPERTY(bool gasSensor MEMBER m_gas_sensor NOTIFY gasSensorChanged)

public:
	Can(QObject *parent = nullptr);

signals:
	void speedChanged(quint16 value);
	void odoChanged(quint32 value);
	void rpmChanged(quint16 value);
	void gearChanged(QString value);
	void gearNumChanged(quint8 value);
	void fuelChanged(quint8 value);
	void gasChanged(quint8 value);
	void parkLightChanged(bool value);
	void highBeamChanged(bool value);
	void backFogChanged(bool value);
	void frontFogChanged(bool value);
	void lowBeamChanged(bool value);
	void leftTurnChanged(bool value);
	void rightTurnChanged(bool value);
	void turnChanged(bool value);
	void doorFLChanged(bool value);
	void doorFRChanged(bool value);
	void doorBLChanged(bool value);
	void doorBRChanged(bool value);
	void trunkChanged(bool value);
	void handbrakeChanged(bool value);
	void absChanged(bool value);
	void engineCheckChanged(bool value);
	void batteryCheckChanged(bool value);
	void oilCheckChanged(bool value);
	void seatbeltChanged(bool value);
	void airbagChanged(bool value);
	void carLockChanged(bool value);
	void outsideTempChanged(qint16 value);
	void errorsChanged(std::vector<int> value);
	void coolantTempChanged(qint16 value);
	void fuelLHChanged(quint16 value);
	void fuelRateChanged(quint16 value);
	void reverseOn();
	void reverseOff();
	void turnSoundChanged(bool value);
	void turnVolumeChanged(qreal value);
	void cameraChanged(bool value);
	void gasSensorChanged(bool value);

private:
//    const char bit_rep[16][5] = {
//        "0000", "0001", "0010", "0011",
//        "0100", "0101", "0110", "0111",
//        "1000", "1001", "1010", "1011",
//        "1100", "1101", "1110", "1111",
//    };

	const unsigned int REAR_CAM_GPIO = 5;
	const unsigned int LEFT_LED_GPIO = 23;
	const unsigned int RIGHT_LED_GPIO = 27;

	QCanBusDevice *m_can0 = nullptr; //GMLAN 33.3k
	QCanBusDevice *m_can1 = nullptr; //STD CAN 500k
	quint16 m_speed = 0; //km / h
	quint32 m_odo = 0;
	quint16 m_rpm = 0;
	QString m_gear = "";
	quint8 m_gear_num = 0;
	quint8 m_fuel = 0; //0 - 255
	quint8 m_gas = 0; //0 - 255
	bool m_break = false;
	bool m_park_light = false;
	bool m_high_beam = false;
	bool m_back_fog = false;
	bool m_front_fog = false;
	bool m_low_beam = false;
	bool m_left_turn = false;
	bool m_right_turn = false;
	bool m_door_fl = false;
	bool m_door_fr = false;
	bool m_door_bl = false;
	bool m_door_br = false;
	bool m_trunk = false;
	bool m_handbrake = false;
	bool m_abs = false;
	bool m_engine_check = false;
	bool m_battery_check = false;
	bool m_oil_check = false;
	bool m_seatbelt = false;
	bool m_airbag = false;
	bool m_car_lock = false;
	qint16 m_outside_temp = 0;
	qint16 m_coolant_temp = 30;
	quint16 m_fuel_lh = 0;
	quint16 m_fuel_rate = 0;

	std::map<quint16, quint8> m_error_map = {{
		{0x0001, 28},
		{0x0002, 16},
		{0x0004, 20},
		{0x0008, 22},
		{0x0010, 19},
		{0x0020, 23},
		{0x0100, 15},
		{0x0200, 25},
		{0x0400, 27},
		{0x0800, 16},
		{0x1000, 18},
		{0x2000, 21},
		{0x4000, 24},
		{0x8000, 26},
	}};

	std::vector<int> m_errors = {};

	std::queue<std::pair<quint32, quint8>> m_odo_fuel;

	QTimer *rearCameraTimerOn;
	QTimer *rearCameraTimerOff;
	QTimer *can1Timer;
	QTimer *tempTimer;

	QSettings settings;

	bool m_turn_sound = false;
	qreal m_turn_volume = 1;
	bool m_camera = true;
	bool m_gas_sensor = true;

	QSoundEffect turnOnSound;
	QSoundEffect turnOffSound;

	void connectDevice();
	void processLights(QByteArray payload);

private slots:
	void processReceivedFrames();

public slots:
	void rearCameraOn();
	void rearCameraOff();
	void can1Tick();
	void tempTick();
	void screenOn();
	void screenOff();

};

#endif // CAN_H
