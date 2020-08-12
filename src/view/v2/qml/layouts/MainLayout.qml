import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtMultimedia 5.8
import dashboard 1.0
import "../"

Item {
	id: mainLayout
	width: 1024
	height: 600
	anchors.centerIn: parent
	focus: true

	Keys.onPressed: {
		console.log(event.key);
		switch(event.key) {
		case Qt.Key_Q:
			Qt.quit();
			break;
		case Qt.Key_P:
			Can.gear = "P"
			break;
		case Qt.Key_R:
			Can.gear = "R"
			break;
		case Qt.Key_N:
			Can.gear = "N"
			break;
		case Qt.Key_D:
			Can.gear = "D"
			break;
		case Qt.Key_Left:
			Can.leftTurn = !Can.leftTurn;
			break;
		}
	}

	Image {
		id: bg
		source: "../../images/bg2.png"
		anchors.centerIn: parent
	}

	Row {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.leftMargin: 30
		anchors.topMargin: 15
		spacing: 20
		property int iconSize: 40

		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/park_light.png"
			opacity: valueSource.parkLight ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/low_beam.png"
			opacity: valueSource.lowBeam ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/high_beam.png"
			opacity: valueSource.highBeam ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/front_fog.png"
			opacity: valueSource.frontFog ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/back_fog.png"
			opacity: valueSource.backFog ? 1 : 0
		}
	}

	Row {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 30
		anchors.topMargin: 15
		spacing: 20
		property int iconSize: 40

		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/handbrake.png"
			opacity: valueSource.handbrake ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/abs.png"
			opacity: valueSource.abs ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/engine_check.png"
			opacity: valueSource.engineCheck ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/battery_check.png"
			opacity: valueSource.batteryCheck ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/oil_check.png"
			opacity: valueSource.oilCheck ? 1 : 0
		}
	}

	CircularGauge {
		id: fuelGauge
		x: 67
		y: 75
		value: valueSource.fuel
		maximumValue: 1
		width: 583
		height: width

		style: FuelStyle {
		}
	}

	CircularGauge {
		width: 470
		height: width
		value: valueSource.rpm
		maximumValue: valueSource.maxRpm
		anchors.centerIn: parent

		style: TachometerStyle {
		}
	}

	CircularGauge {
		x: 367
		y: 75
		value: valueSource.coolantTemp
		minimumValue: 30
		maximumValue: 130
		width: 583
		height: width

		style: CoolantTempStyle {
		}
	}

	Image {
		x: 164
		y: 278
		width: 45
		height: width
		fillMode: Image.PreserveAspectFit
		source: "../../images/doors.png"
		visible: valueSource.doorOpen
	}

	Image {
		x: 810
		y: 278
		width: 45
		height: width
		fillMode: Image.PreserveAspectFit
		source: "../../images/car_lock.png"
		visible: valueSource.carLock
	}

	Column {
		anchors.centerIn: parent
		Text {
			text: valueSource.speed
			font.pixelSize: 110
			color: "#fff"
			anchors.horizontalCenter: parent.horizontalCenter
		}
		Text {
			text: "km/h"
			color: "#bfbfbf"
			font.pixelSize: 30
			anchors.horizontalCenter: parent.horizontalCenter
		}
		Text {
			text: '11.1 L/100km'
			color: '#bfbfbf'
			font.pixelSize: 15
			anchors.horizontalCenter: parent.horizontalCenter
			topPadding: 20
		}
	}

	Text {
		text: valueSource.gear
		font.pixelSize: 80
		x: 600
		y: 375
		color: "#fff"
	}

	Row {
		x: 125
		y: 400
		spacing: 20
		property int iconSize: 40

		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/seatbelt.png"
			opacity: valueSource.seatbelt ? 1 : 0
		}
		Image {
			width: parent.iconSize
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/airbag.png"
			opacity: valueSource.airbag ? 1 : 0
		}
	}

	Column {
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.leftMargin: 0
		anchors.bottomMargin: 30
		width: 310

		Row {
			anchors.right: parent.right

			Text {
				text: "trip"
				font.pixelSize: 17
				color: "#fff"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 5
			}
			Text {
				id: trip
				text: valueSource.trip
				font.pixelSize: 30
				color: "#fff"
				anchors.bottom: parent.bottom
			}
			Text {
				text: "km"
				font.pixelSize: 20
				color: "#fff"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 3
			}
		}
		Row {
			anchors.right: parent.right

			Text {
				text: valueSource.odo
				font.pixelSize: 30
				color: "#fff"
			}
			Text {
				text: "km"
				font.pixelSize: 20
				color: "#fff"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 3
			}
		}
	}

	Image {
		width: 45
		height: width
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.leftMargin: 30
		anchors.bottomMargin: 30
		fillMode: Image.PreserveAspectFit
		source: "../../images/settings.png"
		MouseArea {
			anchors.fill: parent
			onClicked: {
				settingsLayout.visible = true
			}
		}
	}

	Column {
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.rightMargin: 50
		anchors.bottomMargin: 30

		Text {
			text: valueSource.outsideTemp + " °C"
			font.pixelSize: 30
			color: "#fff"
			anchors.right: parent.right
		}
		Text {
			visible: true
			font.pixelSize: 30
			color: "#fff"

			Timer {
				interval: 1000
				running: true
				repeat: true
				triggeredOnStart: true
				onTriggered: {
					parent.text = Qt.formatTime(new Date(), "hh:mm")
				}
			}
		}
	}

	Item {
		width: parent.width
		height: 190
		anchors.bottom: parent.bottom
		visible: valueSource.errorNum !== 0

		Rectangle {
			visible: true
			anchors.fill: parent
			gradient: Gradient {
				GradientStop {
					position: 0.0
					color: "transparent"
				}
				GradientStop {
					position: 0.2
					color: "#ccff0000"
				}
				GradientStop {
					position: 1.0
					color: "#ccff0000"
				}
			}
		}

		Rectangle {
			height: 5
			width: parent.width
			anchors.bottom: parent.bottom
			color: "#ff0000"
		}

		Row {
			anchors.centerIn: parent
			spacing: 20

			Image {
				width: 100
				height: width
				fillMode: Image.PreserveAspectFit
				source: "../../images/alert.png"
				anchors.verticalCenter: parent.verticalCenter
			}

			Column {
				anchors.verticalCenter: parent.verticalCenter
				spacing: 5

				Text {
					text: "ОШИБКА № " + valueSource.errorNum
					color: "#fff"
					font.pixelSize: 35
					font.family: "Arial"
					font.bold: true
				}
				Text {
					text: valueSource.errorText
					color: "#fff"
					font.pixelSize: 30
					font.capitalization: Font.AllUppercase
					font.family: "Arial"
					font.bold: true
				}
			}
		}
	}
}
