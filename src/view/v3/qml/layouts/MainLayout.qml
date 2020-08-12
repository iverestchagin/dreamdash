import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.11
import "../"

Item {
	id: mainLayout
	width: 1024
	height: 600
	anchors.centerIn: parent
	focus: true

	Keys.onPressed: {
		console.log("onPressed key: ", event.key)
		switch (event.key) {
		case Qt.Key_Q:
			Qt.quit()
			break
		case Qt.Key_P:
			Can.gear = "P"
			break
		case Qt.Key_R:
			Can.gear = "R"
			break
		case Qt.Key_N:
			Can.gear = "N"
			break
		case Qt.Key_D:
			Can.gear = "D"
			break
		case Qt.Key_M:
			Can.gear = "M"
			Can.gearNum = 1
			break
		case Qt.Key_Z:
			Can.doorFL = !Can.doorFL
			break;
		case Qt.Key_X:
			Can.doorFR = !Can.doorFR
			break;
		case Qt.Key_C:
			Can.doorBL = !Can.doorBL
			break;
		case Qt.Key_V:
			Can.doorBR = !Can.doorBR
			break;
		case Qt.Key_B:
			Can.trunk = !Can.trunk
			break;
		case Qt.Key_1:
			Can.gearNum = 1
			break
		case Qt.Key_2:
			Can.gearNum = 2
			break
		case Qt.Key_3:
			Can.gearNum = 3
			break
		case Qt.Key_4:
			Can.gearNum = 4
			break
		case Qt.Key_E:

			break
		case Qt.Key_Left:
			Can.leftTurn = !Can.leftTurn
			break
		case Qt.Key_Plus:
			Can.speed += 1
			Can.rpm += 100
			if(Can.fuel < 255) {
				Can.fuel += 1
			}
			if(Can.coolantTemp < valueSource.coolantTempMax) {
				Can.coolantTemp += 5
			}
			break
		case Qt.Key_Minus:
			if(Can.speed > 0) {
				Can.speed -= 1
			}
			if(Can.rpm > 0) {
				Can.rpm -= 100
			}
			if(Can.fuel >= 1) {
				Can.fuel -= 1
			}
			if(Can.coolantTemp > valueSource.coolantTempMin) {
				Can.coolantTemp -= 5
			}
			break
		default:
			console.log('key not handled');
			break
		}
	}

	Image {
		id: bg
		source: "../../images/bg.jpg"
		anchors.centerIn: parent
	}

	Row {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.leftMargin: 40
		anchors.topMargin: 15
		spacing: 14

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/park_light.png"
			opacity: valueSource.parkLight ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/low_beam.png"
			opacity: valueSource.lowBeam ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/high_beam.png"
			opacity: valueSource.highBeam ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/front_fog.png"
			opacity: valueSource.frontFog ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/back_fog.png"
			opacity: valueSource.backFog ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}

	Row {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.leftMargin: 40
		anchors.topMargin: 65
		spacing: 14

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/oil.png"
			opacity: valueSource.oilCheck ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/fuel_icon_active.png"
			opacity: (valueSource.fuel / 255 * 100) < 10 ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}

	Row {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 40
		anchors.topMargin: 15
		spacing: 20

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/temp.png"
			opacity: valueSource.coolantTemp > 110 ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/abs.png"
			opacity: valueSource.abs ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/battery.png"
			opacity: valueSource.batteryCheck ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/carlock.png"
			opacity: valueSource.carLock ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}

	Row {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 40
		anchors.topMargin: 65
		spacing: 20

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/engine.png"
			opacity: valueSource.engineCheck ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}

	Row {
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 40
		anchors.topMargin: 140
		spacing: 20

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/alarm.png"
			opacity: valueSource.handbrake ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/seatbelt.png"
			opacity: valueSource.seatbelt ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}

		Image {
			fillMode: Image.PreserveAspectFit
			source: "../../images/airbag.png"
			opacity: valueSource.airbag ? 1 : 0
			anchors.verticalCenter: parent.verticalCenter
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}

//	CircularGauge {
//		x: 43
//		y: 174
//		value: valueSource.fuel
//		minimumValue: 0
//		maximumValue: 255
//		width: 400
//		height: width

//		style: FuelStyle {
//		}

//		Behavior on value {
//			animation: NumberAnimation { duration: 200 }
//			enabled: !valueSource.demo
//		}
//	}

	RowLayout {
		x: 30
		y: 320
		width: 102

		ColumnLayout {
			width: 51
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

			Text {
				text: (Can.fuel * 100 / 255).toFixed(0)
				color: "#fff"
				font.pixelSize: 20
				Layout.alignment: Qt.AlignHCenter
				Layout.bottomMargin: 0
			}

			Item {
				width: 35
				height: 63
				Layout.alignment: Qt.AlignHCenter

				Image {
					width: parent.width
					height: parent.height
					fillMode: Image.PreserveAspectFit
					source: "../../images/vbar_bg.png"
				}
				Item {
					width: parent.width
					height: (Can.fuel / 255) * parent.height
					clip: true
					anchors.bottom: parent.bottom
					anchors.horizontalCenter: parent.horizontalCenter

					Image {
						width: parent.width
						height: 63
						anchors.bottom: parent.bottom
						anchors.horizontalCenter: parent.horizontalCenter
						source: "../../images/vbar_active.png"
						fillMode: Image.PreserveAspectFit
					}
				}
			}

			Image {
				fillMode: Image.PreserveAspectFit
				source: "../../images/fuel_icon.png"
				Layout.alignment: Qt.AlignHCenter
				Layout.topMargin: 5
			}
		}

		ColumnLayout {
			width: 51
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			visible: Can.gasSensor

			Text {
				text: (Can.gas * 100 / 255).toFixed(0)
				color: "#fff"
				font.pixelSize: 20
				Layout.alignment: Qt.AlignHCenter
				Layout.bottomMargin: 0
			}

			Item {
				width: 35
				height: 63
				Layout.alignment: Qt.AlignHCenter

				Image {
					width: parent.width
					height: parent.height
					fillMode: Image.PreserveAspectFit
					source: "../../images/vbar_bg.png"
				}
				Item {
					width: parent.width
					height: (Can.gas / 255) * parent.height
					clip: true
					anchors.bottom: parent.bottom
					anchors.horizontalCenter: parent.horizontalCenter

					Image {
						width: parent.width
						height: 63
						anchors.bottom: parent.bottom
						anchors.horizontalCenter: parent.horizontalCenter
						source: "../../images/vbar_active.png"
						fillMode: Image.PreserveAspectFit
					}
				}
			}

			Image {
				fillMode: Image.PreserveAspectFit
				source: "../../images/gas_icon.png"
				Layout.alignment: Qt.AlignHCenter
				Layout.leftMargin: 10
				Layout.topMargin: 12
			}
		}
	}

	CircularGauge {
		id: speedometer
		width: 512
		height: width
		value: valueSource.speed
		maximumValue: valueSource.speedMax
		anchors.centerIn: parent
		opacity: 0

		style: SpeedometerStyle {
		}

		SequentialAnimation {
			loops: 1
			running: true
			NumberAnimation {
				target: speedometer
				property: "opacity"
				easing.type: Easing.InOutSine
				from: 0
				to: 1
				duration: 3000
			}
		}

		Behavior on value {
			animation: NumberAnimation { duration: 200 }
			enabled: !valueSource.demo
		}
	}

	Item {
		width: 120
		height: 278
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 151
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.horizontalCenterOffset: -295

		Image {
			width: parent.width
			height: 278
			anchors.bottom: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter
			source: "../../images/tacho_bg.png"
			fillMode: Image.PreserveAspectFit
		}

		Item {
			width: parent.width
			height: (valueSource.rpm / valueSource.rpmMax) * parent.height
			clip: true
			anchors.bottom: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter

			Image {
				width: parent.width
				height: 278
				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter
				source: "../../images/tacho.png"
				fillMode: Image.PreserveAspectFit
			}

			Behavior on height {
				animation: NumberAnimation { duration: 200 }
				enabled: !valueSource.demo
			}
		}
	}

	CircularGauge {
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.rightMargin: -63
		anchors.verticalCenterOffset: 110

		value: valueSource.coolantTemp
		minimumValue: valueSource.coolantTempMin
		maximumValue: valueSource.coolantTempMax
		width: 400
		height: width

		style: CoolantTempStyle {
		}
	}

	Row {
		x: 38
		y: 162
		spacing: 20

		Item {
			width: 51
			height: 68
			Image {
				source: "../../images/doors_closed.png"
				fillMode: Image.PreserveAspectFit
				opacity: (Can.doorFL || Can.doorFR || Can.doorBL || Can.doorBR) ? 1 : 0
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}

			Image {
				source: "../../images/doors_fl.png"
				fillMode: Image.PreserveAspectFit
				opacity: Can.doorFL ? 1 : 0
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}

			Image {
				source: "../../images/doors_fr.png"
				fillMode: Image.PreserveAspectFit
				opacity: Can.doorFR ? 1 : 0
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}

			Image {
				source: "../../images/doors_bl.png"
				fillMode: Image.PreserveAspectFit
				opacity: Can.doorBL ? 1 : 0
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}

			Image {
				source: "../../images/doors_br.png"
				fillMode: Image.PreserveAspectFit
				opacity: Can.doorBR ? 1 : 0
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}
		}

		Image {
			source: "../../images/trunk.png"
			fillMode: Image.PreserveAspectFit
			opacity: Can.trunk ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 200 } }
		}
	}



	Column {
		anchors.centerIn: parent
		anchors.verticalCenterOffset: -15

		Text {
			text: "km/h"
			color: "#fff"
			font.pixelSize: 18
			anchors.horizontalCenter: parent.horizontalCenter
			lineHeight: 0.7
		}
		Text {
			text: valueSource.speed
			font.pixelSize: 120
			lineHeight: 0.9
			color: {
				if(valueSource.speed > 100) {
					return '#e10000'
				}
				else if(valueSource.speed > 70) {
					return '#efba01'
				}
				else {
					return '#ffffff'
				}
			}
			anchors.horizontalCenter: parent.horizontalCenter
		}
		Text {
			text: (Can.fuelLH / 100).toFixed(1) + " L/h"
			color: "#fff"
			font.pixelSize: 16
			anchors.horizontalCenter: parent.horizontalCenter
		}
		Text {
			text: (Can.fuelRate / 100).toFixed(1) + " L/100km"
			color: "#fff"
			font.pixelSize: 18
			anchors.horizontalCenter: parent.horizontalCenter
			visible: Can.fuelRate > 0
		}
	}

	Row {
		id: gearRow
		anchors.left: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		anchors.verticalCenterOffset: 150
		anchors.leftMargin: -3
		spacing: 30
		property string defaultColor: "#525580"
		visible: valueSource.transmission == 'a'

		Text {
			id: gearP
			font.pixelSize: 38
			color: valueSource.gear === this.text ?  "#fff" : gearRow.defaultColor
			text: "P"
			font.bold: true
		}

		Text {
			id: gearR
			font.pixelSize: 38
			color: valueSource.gear === this.text ?  "#fff" : gearRow.defaultColor
			text: "R"
			font.bold: true
		}

		Text {
			id: gearN
			font.pixelSize: 38
			color: valueSource.gear === this.text ?  "#fff" : gearRow.defaultColor
			text: "N"
			font.bold: true
		}
		Text {
			id: gearD
			font.pixelSize: 38
			color: valueSource.gear === this.text ?  "#fff" : gearRow.defaultColor
			text: "D"
			font.bold: true
		}
		Text {
			id: gearM
			font.pixelSize: 38
			color: valueSource.gear === "M" ?  "#fff" : gearRow.defaultColor
			text: "M" + (Can.gearNum === 0 ? "" : Can.gearNum)
			font.bold: true
		}
	}

	Image {
		id: gearGlow
		source: "../../images/gear_glow.png"
		fillMode: Image.PreserveAspectFit
		opacity: 0

		Behavior on x { NumberAnimation { duration: 200 } enabled: gearGlow.opacity > 0 }
		Behavior on y { NumberAnimation { duration: 200 } enabled: gearGlow.opacity > 0 }
		Behavior on opacity { NumberAnimation { duration: 200 } }

		function calcPos() {
			var gear;
			switch(valueSource.gear) {
			case "P":
				gear = gearP
				break
			case "R":
				gear = gearR
				break
			case "N":
				gear = gearN
				break
			case "D":
				gear = gearD
				break
			case "M":
				gear = gearM
				break
			}

			if(gear) {
				if(gear === gearM) {
					this.source = "../../images/gear_glow2.png"
				}
				else {
					this.source = "../../images/gear_glow.png"
				}

				var pos = gear.mapToItem(mainLayout, 0, 0)
				this.x = pos.x - (this.width / 2) + (gear.width / 2)
				this.y = pos.y - (this.height / 2) + (gear.height / 2)

				this.opacity = 1
			}
			else {
				this.opacity = 0
			}
		}

		Component.onCompleted: calcPos()
		Connections {
			target: Can
			onGearChanged: gearGlow.calcPos()
			onGearNumChanged: gearGlow.calcPos()
		}
	}

	Image {
		width: 50
		height: width
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.leftMargin: 15
		anchors.bottomMargin: 15
		fillMode: Image.PreserveAspectFit
		source: "../../images/settings.png"
		MouseArea {
			anchors.fill: parent
			onClicked: {
				settingsLayout.visible = true
			}
		}
	}

	Row {
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.rightMargin: 15
		anchors.bottomMargin: 15

		Image {
			width: 22
			height: width
			fillMode: Image.PreserveAspectFit
			source: "../../images/temperature.png"
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			text: valueSource.outsideTemp + " °C"
			font.pixelSize: 24
			color: "#fff"
		}
	}

	Row {
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottomMargin: 15
		spacing: 5

		Column {
			Text {
				font.pixelSize: 30
				color: "#ffffff"
				lineHeight: 0.9
				anchors.horizontalCenter: parent.horizontalCenter

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
			Text {
				font.pixelSize: 20
				color: "#ffffff"
				lineHeight: 0.9
				anchors.horizontalCenter: parent.horizontalCenter

				Timer {
					interval: 1000
					running: true
					repeat: true
					triggeredOnStart: true
					onTriggered: {
						parent.text = new Date().toLocaleDateString(Qt.locale(), "dd MMMM yyyy")
					}
				}
			}
		}
	}

	Column {
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.verticalCenterOffset: 80
		anchors.rightMargin: 178

		Item {
			width: 200
			height: 30

			Row {
				spacing: 5
				anchors.right: parent.right

				Text {
					text: "TRIP"
					font.pixelSize: 15
					color: "#fff"
					anchors.bottom: parent.bottom
				}
				Text {
					id: trip
					text: (Math.max((valueSource.odo - valueSource.tripStart) / 100, 0)).toFixed(1)
					font.pixelSize: 22
					color: "#fff"
					anchors.bottom: parent.bottom
					lineHeight: 0.9
				}
				Text {
					text: "km"
					font.pixelSize: 15
					color: "#9f9f9f"
					anchors.bottom: parent.bottom
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					tripResetDialog.open()
				}
			}
		}

		Row {
			spacing: 5
			anchors.right: parent.right

			Text {
				text: "ODO"
				font.pixelSize: 15
				color: "#fff"
				anchors.bottom: parent.bottom
			}
			Text {
				text: (valueSource.odo / 100).toFixed(1)
				font.pixelSize: 22
				color: "#fff"
				lineHeight: 0.9
				anchors.bottom: parent.bottom
			}
			Text {
				text: "km"
				font.pixelSize: 15
				color: "#9f9f9f"
				anchors.bottom: parent.bottom
			}
		}
	}

//	Text {
//		text: "SAMPLE"
//		color: "#ff0000"
//		font.pixelSize: 40
//		anchors.bottom: parent.bottom
//		anchors.right: parent.right
//		anchors.rightMargin: 140
//		anchors.bottomMargin: 10
//	}

	Item {
		width: parent.width
		height: 190
		anchors.bottom: parent.bottom
		visible: !valueSource.hideErrors && (Can.errors.length > 0)

		Rectangle {
			visible: true
			anchors.fill: parent
			gradient: Gradient {
				GradientStop {
					position: 0.0
					color: "transparent"
				}
				GradientStop {
					position: 0.3
					color: "#ccff0000"
				}
				GradientStop {
					position: 1.0
					color: "#ccff0000"
				}
			}
		}

		Row {
			anchors.centerIn: parent
			anchors.verticalCenterOffset: 10
			spacing: 20
			leftPadding: 30
			rightPadding: 30

			Image {
				width: 50
				height: width
				fillMode: Image.PreserveAspectFit
				source: "../../images/alert.png"
				anchors.verticalCenter: parent.verticalCenter
			}

			Text {
				anchors.verticalCenter: parent.verticalCenter
				verticalAlignment: Text.AlignVCenter
				text: {
					var text = ''
					for(var num in Can.errors) {
						var n = Can.errors[num];
						if(text.length > 0) {
							text += "\n"
						}
						text += qsTr("ОШИБКА № %1").arg(n) + (valueSource.errorTexts[n] ? (": " + valueSource.errorTexts[n]) : "")
					}
					return text + App.translateTrigger
				}
				color: "#fff"
				font.pixelSize: 18
				font.capitalization: Font.AllUppercase
				font.bold: true
				lineHeight: 1.2
			}
		}

		MouseArea {
			anchors.fill: parent
			onClicked: Can.errors = []
		}
	}

	MessageDialog {
		id: tripResetDialog
		title: qsTr("Сбросить trip?") + App.translateTrigger
		text: qsTr("Вы уверены что хотите сбросить trip?") + App.translateTrigger
		standardButtons: StandardButton.Yes | StandardButton.No
		onYes: {
			valueSource.tripStart = valueSource.odo
		}
		onNo: rebootDialog.visible = false
	}
}
