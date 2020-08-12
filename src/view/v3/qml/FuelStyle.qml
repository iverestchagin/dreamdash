import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

BaseGaugeStyle {
	minimumValueAngle: -109
	maximumValueAngle: -74

	tickmark: null
	minorTickmark: null
	tickmarkLabel: null
	foreground: null

	background: Item {
		Image {
			width: 99
			height: 168
			source: "../images/fuel_bg.png"
			fillMode: Image.PreserveAspectFit
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	needle: Item {
		implicitWidth: 3
		implicitHeight: 0.97 * outerRadius

		Image {
			width: 11
			height: 40
			source: "../images/arrow1_cold.png"
			fillMode: Image.PreserveAspectFit
		}
	}
}
