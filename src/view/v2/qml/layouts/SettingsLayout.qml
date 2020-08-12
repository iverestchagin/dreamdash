import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtMultimedia 5.9
import dashboard 1.0

Item {
	id: settingsLayout
	width: root.width
	height: Math.min(root.width, root.height)
	anchors.centerIn: parent
	visible: false

	Material.theme: Material.Dark
	Material.accent: Material.Pink

	Rectangle {
		anchors.fill: parent
		color: "#000"
	}

	Text {
		id: title
		text: qsTr("Настройки")
		font.pixelSize: 60
		color: "#fff"
		x: 30
		y: 30
	}

	Column {
		anchors.top: title.bottom
		anchors.left: parent.left
		anchors.topMargin: 30
		anchors.leftMargin: 30
		spacing: 10

		Text {
			text: qsTr("Звук поворотников:")
			font.pixelSize: 35
			color: "#fff"
		}

		Row {
			spacing: 30

			RadioButton {
				text: qsTr("Встроенный динамик")
				checked: valueSource.turnSound
				onCheckedChanged: {
					valueSource.turnSound = checked
				}
				font.pixelSize: 25
				indicator.width: 30
				indicator.height: 30
			}

			RadioButton {
				text: qsTr("Штатные динамики")
				checked: !valueSource.turnSound
				font.pixelSize: 25
				indicator.width: 30
				indicator.height: 30
			}
		}

		Row {
			spacing: 30
			visible: valueSource.turnSound

			Text {
				text: qsTr("Громкость:")
				font.pixelSize: 35
				color: "#fff"
				anchors.verticalCenter: parent.verticalCenter
			}

			Slider {
				id: volumeSlider
				value: QtMultimedia.convertVolume(valueSource.turnVolume, QtMultimedia.LinearVolumeScale, QtMultimedia.LogarithmicVolumeScale)
				stepSize: 0.1
				from: 0.1
				to: 1
				width: 600

				onValueChanged: {
					valueSource.turnVolume = QtMultimedia.convertVolume(volumeSlider.value, QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)
					console.warn(volumeSlider.value, valueSource.turnVolume);
				}
			}
		}

		Row {
			spacing: 30
			Text {
				text: qsTr("Язык:")
				font.pixelSize: 35
				color: "#fff"
				anchors.verticalCenter: parent.verticalCenter
			}

			ComboBox {
				id: langControl
				currentIndex: valueSource.langId
				model: ["Русский", "English", "Uzbek"]
				font.pixelSize: 35
				width: 600
				height: 90
				delegate: ItemDelegate {
					width: parent.width
					contentItem: Text {
						text: modelData
						color: "#000"
						elide: Text.ElideRight
						verticalAlignment: Text.AlignVCenter
						font.pixelSize: 35
					}
					highlighted: langControl.highlightedIndex === index
				}
				popup: Popup {
					y: langControl.height
					width: langControl.width
					implicitHeight: contentItem.implicitHeight
					padding: 0

					contentItem: ListView {
						clip: true
						implicitHeight: contentHeight
						model: langControl.popup.visible ? langControl.delegateModel : null
						currentIndex: langControl.highlightedIndex

						ScrollIndicator.vertical: ScrollIndicator { }
					}
					background: Rectangle {
						radius: 1
					}
				}
			}
		}

		Row {
			spacing: 30

			Button {
				text: qsTr("Перезагрузить")
				onClicked: {
					rebootDialog.open()
				}
			}
			Button {
				text: qsTr("Выключить")
				onClicked: {
					shutdownDialog.open()
				}
			}
		}

		Row {
			spacing: 30

			Button {
				visible: !valueSource.demo
				text: qsTr("Включить демо режим")
				onClicked: {
					valueSource.demo = true
				}
			}

			Button {
				visible: valueSource.demo
				text: qsTr("Отключить демо режим")
				onClicked: {
					valueSource.demo = false
				}
			}
		}
	}

	Image {
		width: 90
		height: width
		fillMode: Image.PreserveAspectFit
		source: "qrc:/view/base/images/close.png"
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 20
		anchors.topMargin: 20

		MouseArea {
			anchors.fill: parent
			onClicked: {
				settingsLayout.visible = false
			}
		}
	}

	Image {
		width: 90
		height: width
		fillMode: Image.PreserveAspectFit
		source: "qrc:/view/base/images/camera.png"
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.rightMargin: 30
		anchors.bottomMargin: 30

		MouseArea {
			anchors.fill: parent
			onClicked: {
				reverseLayout.visible = true
				Can.rearCameraOn()
			}
		}
	}

	MessageDialog {
		id: rebootDialog
		title: qsTr("Перезагрузить панель")
		text: qsTr("Вы уверены что хотите перезагрузить устройство")
		standardButtons: StandardButton.Yes | StandardButton.No
		onYes: App.reboot()
		onNo: rebootDialog.visible = false
	}

	MessageDialog {
		id: shutdownDialog
		title: qsTr("Выключить панель")
		text: qsTr("Вы уверены что хотите выключить устройство")
		standardButtons: StandardButton.Yes | StandardButton.No
		onYes: App.shutdown()
		onNo: shutdownDialog.visible = false
	}
}
