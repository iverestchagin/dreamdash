import QtQuick 2.10
import QtMultimedia 5.8
import Qt.labs.settings 1.0

Item {
	id: valueSource

	property bool isStarted: true
	property bool demo: false

	property int speed: Can.speed
	property int speedMax: 200
	property int rpm: Can.rpm
	property int rpmMax: 8000
	property int fuel: Can.fuel
	property int coolantTemp: Can.coolantTemp
	property int coolantTempMin: 30
	property int coolantTempMax: 130

	property int tripStart: 0
	property int odo: Can.odo
	property string gear: Can.gear

	property bool parkLight: Can.parkLight
	property bool carLock: Can.carLock
	property bool lowBeam: Can.lowBeam
	property bool highBeam: Can.highBeam
	property bool frontFog: Can.frontFog
	property bool backFog: Can.backFog
	property bool seatbelt: Can.seatbelt
	property bool airbag: Can.airbag
	property bool abs: Can.abs
	property bool handbrake: Can.handbrake
	property bool engineCheck: Can.engineCheck
	property bool batteryCheck: Can.batteryCheck
	property bool oilCheck: Can.oilCheck

	property int outsideTemp: Can.outsideTemp

	property var errorTexts: {
		15: qsTr("Неисправность верхнего стоп-сигнала") + App.translateTrigger,
		16: qsTr("Необходимо обслуживание стоп-сигналов") + App.translateTrigger,
		18: qsTr("Неисправна цепь ближнего света левой блок-фары") + App.translateTrigger,
		19: qsTr("Неисправен задний противотуманный фонарь") + App.translateTrigger,
		20: qsTr("Неисправна цепь ближнего света правой блок-фары") + App.translateTrigger,
		21: qsTr("Неисправен левый передний габарит") + App.translateTrigger,
		22: qsTr("Неисправен правый передний габарит") + App.translateTrigger,
		23: qsTr("Неисправен фонарь заднего хода") + App.translateTrigger,
		24: qsTr("Неисправно освещение номерного знака") + App.translateTrigger,
		25: qsTr("Неисправен левый передний поворотник") + App.translateTrigger,
		26: qsTr("Неисправен левый задний поворотник") + App.translateTrigger,
		27: qsTr("Неисправен правый передний поворотник") + App.translateTrigger,
		28: qsTr("Неисправен правый задний поворотник") + App.translateTrigger,
		84: qsTr("Снижение мощности двигателя") + App.translateTrigger,
		89: qsTr("Пришло время выполнить техническое обслуживание автомобиля") + App.translateTrigger,
		128: qsTr("Открыт капот") + App.translateTrigger
	}

	property var langValues: [
		"Русский",
		"English",
		"Uzbek"
	]
	property var langKeys: [
		"ru",
		"en",
		"uz"
	]
	property string lang: "ru"
	property string transmission: "a"
	property bool hideErrors: false

	Settings {
		id: settings
		property alias lang: valueSource.lang
		property alias tripStart: valueSource.tripStart
		property alias transmission: valueSource.transmission
		property alias hideErrors: valueSource.hideErrors
	}

	Connections {
		target: Can
		onOdoChanged: {
			if(tripStart == 0) {
				tripStart = value
			}
		}
	}

	SequentialAnimation {
		running: demo && isStarted
		loops: Animation.Infinite

		NumberAnimation {
			target: Can
			property: "speed"
			easing.type: Easing.InOutSine
			from: 0
			to: 199
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
		NumberAnimation {
			target: Can
			property: "speed"
			easing.type: Easing.InOutSine
			from: 199
			to: 0
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
	}

	SequentialAnimation {
		running: demo && isStarted
		loops: Animation.Infinite

		NumberAnimation {
			target: Can
			property: "rpm"
			easing.type: Easing.Linear
			from: 0
			to: valueSource.rpmMax
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
		NumberAnimation {
			target: Can
			property: "rpm"
			easing.type: Easing.Linear
			from: valueSource.rpmMax
			to: 0
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
	}

	SequentialAnimation {
		running: demo && isStarted
		loops: Animation.Infinite

		NumberAnimation {
			target: Can
			property: "fuel"
			easing.type: Easing.InOutSine
			from: 0
			to: 255
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
		NumberAnimation {
			target: Can
			property: "fuel"
			easing.type: Easing.InOutSine
			from: 255
			to: 0
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
	}

	SequentialAnimation {
		running: demo && isStarted
		loops: Animation.Infinite

		NumberAnimation {
			target: Can
			property: "coolantTemp"
			easing.type: Easing.InOutSine
			from: valueSource.coolantTempMin
			to: valueSource.coolantTempMax
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
		NumberAnimation {
			target: Can
			property: "coolantTemp"
			easing.type: Easing.InOutSine
			from: valueSource.coolantTempMax
			to: valueSource.coolantTempMin
			duration: 10000
		}
		PauseAnimation {
			duration: 1000
		}
	}

	ParallelAnimation {
		running: demo && isStarted
		loops: Animation.Infinite

		SequentialAnimation {
			PropertyAction { target: Can; property: "highBeam"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "highBeam"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "lowBeam"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "lowBeam"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "frontFog"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "frontFog"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "backFog"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "backFog"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "parkLight"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "parkLight"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "carLock"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "carLock"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "abs"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "abs"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "handbrake"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "handbrake"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "oilCheck"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "oilCheck"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "batteryCheck"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "batteryCheck"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "engineCheck"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "engineCheck"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "carLock"; value: true; }
			PauseAnimation { duration: 1000 }
			PropertyAction { target: Can; property: "carLock"; value: false; }
			PauseAnimation { duration: 1000 }
		}

		SequentialAnimation {
			PropertyAction { target: Can; property: "leftTurn"; value: true; }
			PropertyAction { target: Can; property: "rightTurn"; value: true; }
			PauseAnimation { duration: 500 }

			PropertyAction { target: Can; property: "leftTurn"; value: false; }
			PropertyAction { target: Can; property: "rightTurn"; value: false; }
			PauseAnimation { duration: 500 }
		}
	}
}
