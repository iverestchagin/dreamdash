﻿import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

BaseGaugeStyle {
    minimumValueAngle: -90
    maximumValueAngle: -32
    tickmarkStepSize: 0.5
    minorTickmarkCount: 1
    tickmarkInset: 7
    minorTickmarkInset: 17

    tickmark: Rectangle {
        width: 4
        height: 25
        antialiasing: true
        color: Qt.rgba(1, 1, 1, 1)
    }

    minorTickmark: Rectangle {
        width: 4
        height: 15
        antialiasing: true
        color: Qt.rgba(1, 1, 1, 1)
    }

    background: Canvas {
        property real value: control.value

//        onValueChanged: requestPaint()

        onPaint: {
            var lineWidth = 30

            var ctx = getContext("2d")
            ctx.reset()

//            ctx.beginPath()
//            ctx.lineWidth = lineWidth
//            ctx.strokeStyle = "#d00000"
//            ctx.arc(outerRadius, outerRadius,
//                    outerRadius - ctx.lineWidth / 2, degToRad(
//                        valueToAngle(control.minimumValue) - 90), degToRad(
//                        valueToAngle(Math.min(control.maximumValue / 4,
//                                              control.value)) - 90))
//            ctx.stroke()

//            if (control.value > control.maximumValue / 4) {
//                ctx.beginPath()
//                ctx.lineWidth = lineWidth
//                ctx.strokeStyle = "#1e5db2"
//                ctx.arc(outerRadius, outerRadius,
//                        outerRadius - ctx.lineWidth / 2, degToRad(
//                            valueToAngle(control.maximumValue / 4) - 90),
//                        degToRad(valueToAngle(control.value) - 90))
//                ctx.stroke()
//            }

            ctx.beginPath()
            ctx.lineWidth = 5
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.6)
            ctx.arc(outerRadius, outerRadius,
                    outerRadius - ctx.lineWidth / 2 - lineWidth,
                    degToRad(valueToAngle(control.minimumValue) - 90),
                    degToRad(valueToAngle(control.maximumValue) - 90))
            ctx.stroke()
        }
    }

    needle: Item {
        property real needleHeight: 50
        property real needleWidth: 15
        height: outerRadius
        y: -10
        x: -10

        Canvas {
            id: needle
            width: needleWidth
            height: needleHeight
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                ctx.beginPath()
                ctx.moveTo(width / 2, 0)
                ctx.lineTo(width, needleHeight)
                ctx.lineTo(0, needleHeight)
                ctx.closePath()
                ctx.fillStyle = "#f40011"
                ctx.fill()
            }
        }
        Glow {
            anchors.fill: needle
            radius: 6
            samples: 10
            color: "black"
            source: needle
        }
    }
}
