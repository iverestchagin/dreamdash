import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

BaseGaugeStyle {
	minimumValueAngle: -19
	maximumValueAngle: 17
	labelStepSize: 50
	tickmark: null
	minorTickmark: null
	labelInset: -11

	tickmarkLabel: Text {
		font.pixelSize: 13
		font.bold: true
		text: styleData.value + "°"
		color: {
			if(styleData.value > 100) {
				return '#e10000'
			}
			else if(styleData.value > 95) {
				return '#efba01'
			}
			else {
				return '#ffffff'
			}
		}

		antialiasing: true
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}

	foreground: Item {
		anchors.fill: parent
		Row {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			spacing: 10

			Text {
				text: control.value + "°C"
				font.pixelSize: 17
				anchors.bottom: parent.bottom
				color: {
					if(control.value > 100) {
						return '#e10000'
					}
					else if(control.value > 95) {
						return '#efba01'
					}
					else {
						return '#ffffff'
					}
				}
			}
			Image {
				width: 20
				height: width
				source: "../images/coolant.png"
				fillMode: Image.PreserveAspectFit
				verticalAlignment: Image.AlignTop
				anchors.bottom: parent.bottom
			}
		}
	}

	background: Item {
		Image {
			width: 137
			height: width
			source: "../images/coolant_bg.png"
			fillMode: Image.PreserveAspectFit
			anchors.top: parent.top
			anchors.horizontalCenter: parent.horizontalCenter
			verticalAlignment: Image.AlignTop
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
