/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

BaseGaugeStyle {
    tickmarkStepSize: 1000
    labelStepSize: 1
    minimumValueAngle: -180
    maximumValueAngle: 90
    minorTickmarkCount: 3

    tickmark: Rectangle {
        width: 4
        height: 28
        antialiasing: true
        color: Qt.rgba(1, 1, 1, 0.6)
    }

    minorTickmark: Rectangle {
        width: 4
        height: 18
        antialiasing: true
        color: Qt.rgba(1, 1, 1, 0.6)
    }

//    tickmarkLabel: Text {
//        font.pixelSize: Math.max(6, toPixels(20))
//        font.bold: true
//        text: styleData.value
//        color: styleData.index === 6 || styleData.index === 7 || styleData.index === 8 ? Qt.rgba(0.5, 0, 0, 1) : "#fff"
//        antialiasing: true
//    }

    background: Canvas {
        property int value: control.value

//        onValueChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

//            ctx.beginPath();
//            ctx.lineWidth = 45;
//            ctx.strokeStyle = "#1e5db2";
//            ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degToRad(valueToAngle(control.minimumValue) - 90), degToRad(valueToAngle(Math.min(6000, control.value)) - 90));
//            ctx.stroke();

//            if(control.value > 6000) {
//                ctx.beginPath();
//                ctx.lineWidth = 45;
//                ctx.strokeStyle = "#d00000";
//                ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degToRad(valueToAngle(6000) - 90), degToRad(valueToAngle(control.value) - 90));
//                ctx.stroke();
//            }

            ctx.beginPath();
            ctx.lineWidth = 5;
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.6);
            ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2, degToRad(valueToAngle(control.minimumValue) - 90), degToRad(valueToAngle(control.maximumValue) - 90));
            ctx.stroke();
        }
    }

    needle: Item {
        property real needleHeight: 50
        property real needleWidth: 15

        height: outerRadius
        y: -needleHeight * 0.2
        x: -needleWidth / 2

        Canvas {
            id: needle
            width: needleWidth
            height: needleHeight
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

//                ctx.beginPath();
//                ctx.moveTo(0, 0);
//                ctx.lineTo(width, 0);
//                ctx.lineTo(width, height);
//                ctx.lineTo(0, height);
//                ctx.closePath();
//                ctx.lineWidth = 4;
//                ctx.strokeStyle = "white";
//                ctx.stroke();

//                ctx.beginPath();
//                ctx.moveTo(width / 2 - 2, needleHeight);
//                ctx.lineTo(width / 2 + 2, needleHeight);
//                ctx.lineTo(width, 0);
//                ctx.lineTo(0, 0);
//                ctx.closePath();
//                ctx.lineWidth = 4;
//                ctx.strokeStyle = "#99000000";
//                ctx.stroke();

                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.lineTo(width / 2, height);
                ctx.closePath();
                ctx.fillStyle = Qt.rgba(0.96, 0, 0.07, 1);
                ctx.fill();
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

    foreground: null
}
