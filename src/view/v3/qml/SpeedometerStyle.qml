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
	tickmarkStepSize: 0
	labelStepSize: 20
	minimumValueAngle: -150
	maximumValueAngle: 90
	minorTickmarkCount: 0
	labelInset: 74

	tickmark: null

	tickmarkLabel: Text {
		font.pixelSize: 21
		font.bold: true
		text: styleData.value
		color: {
			if(styleData.value > 100) {
				return '#e10000'
			}
			else if(styleData.value > 70) {
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

	background: Image {
		anchors.fill: parent
		anchors.centerIn: parent
		source: "../images/speed_bg.png"
		fillMode: Image.PreserveAspectFit
	}

	needle: Item {
		implicitWidth: 77
		implicitHeight: 292

		Image {
			anchors.fill: parent
			anchors.centerIn: parent
			anchors.bottomMargin: -172
			source: {
				return "../images/arrow_short_red.png"
//				if(control.value > 100) {
//					return "../images/arrow_short_red.png"
//				}
//				else if(control.value > 70) {
//					return "../images/arrow_short_yellow.png"
//				}
//				else {
//					return "../images/arrow_short_green.png"
//				}
			}
			fillMode: Image.PreserveAspectFit
		}
	}

	foreground: null
}
