import QtQuick 2.11
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtMultimedia 5.9

Item {
	id: settingsLayout
	width: root.width
	height: Math.min(root.width, root.height)
	anchors.centerIn: parent
	visible: false

	Material.theme: Material.Dark
	Material.accent: Material.Pink

	onVisibleChanged: {
		if(visible) {
			var d = new Date()
			year.text = d.getFullYear()
			month.text = d.getMonth() + 1
			day.text = d.getDate()
			hour.text = d.getHours()
			minute.text = d.getMinutes()
			second.text = d.getSeconds()
		}
	}

	Rectangle {
		anchors.fill: parent
		color: "#000"
	}

	Column {
		id: header
		x: 30
		y: 30

		Text {
			text: qsTr("Настройки") + App.translateTrigger
			font.pixelSize: 50
			color: "#fff"
		}

		Text {
			text: "Version: " + Qt.application.version
			font.pixelSize: 15
			color: "#fff"
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
				mainLayout.focus = true
			}
		}
	}

	ScrollView {
		anchors.top: header.bottom
		anchors.topMargin: 30
		anchors.bottom: parent.bottom
		width: parent.width
		contentWidth: parent.width
		ScrollBar.horizontal.interactive: true
		ScrollBar.vertical.interactive: true
		clip: true

		Column {
			id: list
			spacing: 10
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 30
			anchors.rightMargin: 30

			GroupBox {
				width: parent.width

				label: Text {
					text: qsTr("Звук поворотников:") + App.translateTrigger
					font.pixelSize: 30
					color: "#fff"
				}

				Column {
					RadioButton {
						text: qsTr("Встроенный динамик") + App.translateTrigger
						checked: Can.turnSound
						onCheckedChanged: {
							Can.turnSound = checked
						}
						font.pixelSize: 25
						indicator.width: 30
						indicator.height: indicator.width
					}

					Row {
						spacing: 30
						visible: Can.turnSound
						leftPadding: 50

						Text {
							text: qsTr("Громкость:") + App.translateTrigger
							font.pixelSize: 20
							color: "#fff"
							anchors.verticalCenter: parent.verticalCenter
						}

						Slider {
							id: volumeSlider
							value: QtMultimedia.convertVolume(Can.turnVolume, QtMultimedia.LinearVolumeScale, QtMultimedia.LogarithmicVolumeScale)
							stepSize: 0.01
							from: 0.1
							to: 1
							width: 670

							onValueChanged: {
								Can.turnVolume = QtMultimedia.convertVolume(volumeSlider.value, QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)
//								console.warn(volumeSlider.value, valueSource.turnVolume);
							}
						}
					}

					RadioButton {
						text: qsTr("Штатные динамики") + App.translateTrigger
						checked: !Can.turnSound
						font.pixelSize: 25
						indicator.width: 30
						indicator.height: 30
					}
				}
			}

			GroupBox {
				width: parent.width
				label: Text {
					text: qsTr("Язык:") + App.translateTrigger
					font.pixelSize: 30
					color: "#fff"
				}

				Column {
					ComboBox {
						id: langControl
						currentIndex: valueSource.langKeys.indexOf(valueSource.lang)
						model: valueSource.langValues
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
						onActivated: {
							valueSource.lang = valueSource.langKeys[index]
							App.selectLanguage(valueSource.lang);
						}
					}
				}
			}

			GroupBox {
				width: parent.width
				label: Text {
					text: qsTr("Дата:") + App.translateTrigger
					font.pixelSize: 30
					color: "#fff"
				}

				Column {
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
								parent.text = new Date().toLocaleString(Qt.locale(), "dd MMMM yyyy hh:mm:ss")
							}
						}
					}

					Row {
						spacing: 15

						Row {
							spacing: 5
							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: year.text = parseInt(year.text) + 1
								}
								Text {
									id: year
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: year.text = parseInt(year.text) - 1
								}
							}
							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: {
										let m = parseInt(month.text)
										if(m < 12) {
											m ++
											month.text = m

											let maxDay = new Date(year.text, month.text, 0).getDate()
											if(parseInt(day.text) > maxDay) {
												day.text = maxDay
											}
										}
									}
								}
								Text {
									id: month
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: {
										let m = parseInt(month.text)
										if(m > 1) {
											m --
											month.text = m

											let maxDay = new Date(year.text, month.text, 0).getDate()
											if(parseInt(day.text) > maxDay) {
												day.text = maxDay
											}
										}
									}
								}
							}
							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: {
										let d = parseInt(day.text)
										let maxDay = new Date(year.text, month.text, 0).getDate()
										if(d < maxDay) {
											d ++
											day.text = d
										}
									}
								}
								Text {
									id: day
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: {
										let d = parseInt(day.text)
										if(d > 1) {
											d --
											day.text = d
										}
									}
								}
							}
						}
						Row {
							spacing: 5

							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: {
										let h = parseInt(hour.text)
										if(h < 23) {
											h ++
											hour.text = h
										}
									}
								}
								Text {
									id: hour
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: {
										let h = parseInt(hour.text)
										if(h > 0) {
											h --
											hour.text = h
										}
									}
								}
							}

							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: {
										let m = parseInt(minute.text)
										if(m < 59) {
											m ++
											minute.text = m
										}
									}
								}
								Text {
									id: minute
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: {
										let m = parseInt(minute.text)
										if(m > 0) {
											m --
											minute.text = m
										}
									}
								}
							}

							Column {
								width: 100
								Button {
									text: "+"
									width: parent.width
									onClicked: {
										let s = parseInt(second.text)
										if(s < 59) {
											s ++
											second.text = s
										}
									}
								}
								Text {
									id: second
									color: "#fff"
									width: parent.width
									horizontalAlignment: Text.AlignHCenter
									font.pixelSize: 20
								}
								Button {
									text: "-"
									width: parent.width
									onClicked: {
										let s = parseInt(second.text)
										if(s > 0) {
											s --
											second.text = s
										}
									}
								}
							}
						}
					}

					Button {
						text: qsTr("Сохранить") + App.translateTrigger
						anchors.horizontalCenter: parent.horizontalCenter
						onClicked: {
							App.setDate(year.text + "-" + month.text + "-" + day.text + " " + hour.text + ":" + minute.text + ":" + second.text)
						}
					}
				}
			}

			GroupBox {
				width: parent.width

				label: Text {
					text: qsTr("Тип трансмиссии:") + App.translateTrigger
					font.pixelSize: 30
					color: "#fff"
				}

				Column {
					RadioButton {
						text: qsTr("Автомат") + App.translateTrigger
						checked: valueSource.transmission == 'a'
						onCheckedChanged: {
							if(checked) {
								valueSource.transmission = 'a'
							}
						}
						font.pixelSize: 25
						indicator.width: 30
						indicator.height: indicator.width
					}

					RadioButton {
						text: qsTr("Механика") + App.translateTrigger
						checked: valueSource.transmission == 'm'
						onCheckedChanged: {
							if(checked) {
								valueSource.transmission = 'm'
							}
						}
						font.pixelSize: 25
						indicator.width: 30
						indicator.height: 30
					}
				}
			}

			GroupBox {
				width: parent.width

//				label: Text {
//					text: qsTr("Камера заднего хода:") + App.translateTrigger
//					font.pixelSize: 30
//					color: "#fff"
//				}

				Column {
					CheckBox {
						text: qsTr("Камера заднего хода") + App.translateTrigger
						font.pixelSize: 30
						checked: Can.camera == true
						onCheckedChanged: {
							Can.camera = checkState
						}
					}

					CheckBox {
						text: qsTr("Датчик ГБО") + App.translateTrigger
						font.pixelSize: 30
						checked: Can.gasSensor == true
						onCheckedChanged: {
							Can.gasSensor = checkState
						}
					}

					CheckBox {
						text: qsTr("Скрыть ошибки") + App.translateTrigger
						font.pixelSize: 30
						checked: valueSource.hideErrors == true
						onCheckedChanged: {
							valueSource.hideErrors = checkState
						}
					}
				}
			}

			Item {
				width: parent.width
				height: 100

				Row {
					spacing: 30
					Button {
						text: qsTr("Перезагрузить")
						onClicked: {
							rebootDialog.open()
						}
					}

//					Button {
//						visible: !valueSource.demo
//						text: qsTr("Включить демо режим")
//						onClicked: {
//							valueSource.demo = true
//						}
//					}

//					Button {
//						visible: valueSource.demo
//						text: qsTr("Отключить демо режим")
//						onClicked: {
//							valueSource.demo = false
//						}
//					}
				}

				Image {
					width: 70
					height: 100
					fillMode: Image.PreserveAspectFit
					source: "qrc:/view/base/images/camera.png"
					anchors.right: parent.right
					anchors.rightMargin: 0
					verticalAlignment: Image.AlignVCenter
					visible: Can.camera

					MouseArea {
						anchors.fill: parent
						onClicked: {
							reverseLayout.visible = true
							Can.rearCameraOn()
						}
					}
				}
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
}
