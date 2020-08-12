import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.2
import "layouts"
import "../../base/qml"

ApplicationWindow {
	id: root
	visible: true
	width: 1024
	height: 600
	visibility: "AutomaticVisibility"
	color: "#000"
	title: "DreamDash"

	ValueSource {
		id: valueSource
	}

	MainLayout {
		id: mainLayout
	}

	SettingsLayout {
		id: settingsLayout
	}

	ReverseLayout {
		id: reverseLayout
	}

	Component.onCompleted: {
//		console.warn(Screen.width, 'x', Screen.height, Screen.pixelDensity);
		App.start();
	}
}
