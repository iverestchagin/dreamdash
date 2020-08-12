import QtQuick 2.11
import QtQuick.Controls 2.4
import QtMultimedia 5.8

Item {
	id: reverseLayout
	width: root.width
	height: Math.min(root.width, root.height)
	anchors.centerIn: parent
	visible: false

	Connections {
		target: Can
		onReverseOn: {
			reverseLayout.visible = true
		}
		onReverseOff: {
			reverseLayout.visible = false
		}
	}

	Rectangle {
		anchors.fill: parent
		color: "#000"
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			reverseLayout.visible = false
			Can.rearCameraOff()
		}
	}

//    VideoOutput {
//        id: video
//        source: camera
//        autoOrientation: true
//        fillMode: VideoOutput.PreserveAspectCrop
//        anchors.fill: parent

//        Camera {
//            id: camera
//            captureMode: Camera.CaptureViewfinder
//            cameraState: Camera.LoadedState
//            onError: {
//                cameraStatus.text = "Error: " + errorCode + " " + errorString
//            }
//            onCameraStateChanged: {
//                if(cameraState == Camera.ActiveState) {
//                    cameraStatus.text = ""
//                }
//            }
//        }
//    }

//    Text {
//        id: cameraStatus
//        anchors.centerIn: parent
//        font.pixelSize: 50
//        color: "#fff"
//        text: ""
//    }

//    Image {
//        width: 90
//        height: width
//        fillMode: Image.PreserveAspectFit
//        source: "qrc:/v2/images/close.png"
//        anchors.right: parent.right
//        anchors.top: parent.top
//        anchors.rightMargin: 30
//        anchors.topMargin: 30

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                reverseLayout.hide()
//            }
//        }
//    }
}
