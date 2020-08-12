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

#include <app.h>
#include <can.h>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QQmlContext>
#include <QDebug>
#include <QQuickStyle>
#include <QLocale>
#include <QTranslator>

void loadV2(QGuiApplication &qtApp, QQmlApplicationEngine &engine) {
	QFontDatabase::addApplicationFont(":/view/v2/fonts/CONC_BI.TTF");
	qtApp.setFont(QFont("a_Concepto"));

	engine.load(QUrl("qrc:/view/v2/qml/dashboard.qml"));
}

void loadV3(QGuiApplication &qtApp, QQmlApplicationEngine &engine) {
	QFontDatabase::addApplicationFont(":/view/v3/fonts/CONTHRAX-SB.TTF");
	qtApp.setFont(QFont("Conthrax"));

	engine.load(QUrl("qrc:/view/v3/qml/dashboard.qml"));
}

int main(int argc, char *argv[])
{
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QGuiApplication qtApp(argc, argv);
	qtApp.setApplicationVersion(APP_VERSION);
	qtApp.setOrganizationName("DreamDash Ltd.");
	qtApp.setOrganizationDomain("dreamdash.uz");
	qtApp.setApplicationName("DreamDash");
	QQuickStyle::setStyle("Material");
	QSettings settings;

	Can *can = new Can();
	App *app = new App(can);
	app->selectLanguage(settings.value("lang").toString());

//	qmlRegisterSingletonType<App>("dashboard", 1, 0, "App", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
//		Q_UNUSED(engine)
//		Q_UNUSED(scriptEngine)
//		return new App();
//	});

//	qmlRegisterSingletonType<Can>("dashboard", 1, 0, "Can", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
//		Q_UNUSED(engine)
//		Q_UNUSED(scriptEngine)
//		return new Can();
//	});

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("App", app);
	engine.rootContext()->setContextProperty("Can", can);

	loadV3(qtApp, engine);

	if (engine.rootObjects().isEmpty())
		return -1;
	return qtApp.exec();
}


