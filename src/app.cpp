#include "app.h"
#include <QProcess>
#include <QTimer>
#include <QDebug>
#include <QtGui/QGuiApplication>
#include <QTranslator>
#include <QDir>

App::App(Can *can, QObject *parent) : QObject(parent)
{
	qDebug("App created");
	this->can = can;
	mmapGpio* rpiGpio = mmapGpio::getInstance();

	rpiGpio->setPinDir(ACC_PIN, mmapGpio::INPUT);
	rpiGpio->setPinDir(SCREEN_POWER_PIN, mmapGpio::OUTPUT);
	rpiGpio->writePinHigh(SCREEN_POWER_PIN);

	translator = new QTranslator();

	this->screenOnTimer = new QTimer(this);
	this->screenOnTimer->setSingleShot(true);
	connect(this->screenOnTimer, SIGNAL(timeout()), this, SLOT(screenOn()));
	connect(this->screenOnTimer, SIGNAL(timeout()), can, SLOT(screenOn()));

	this->screenOffTimer = new QTimer(this);
	this->screenOffTimer->setSingleShot(true);
	connect(this->screenOffTimer, SIGNAL(timeout()), this, SLOT(screenOff()));
	connect(this->screenOffTimer, SIGNAL(timeout()), can, SLOT(screenOff()));

	QTimer *timer = new QTimer(this);
	connect(timer, SIGNAL(timeout()), this, SLOT(checkPower()));
	timer->start(1000);
}

void App::start() {
	qDebug() << "App::start()";
}

void App::reboot() {
	QProcess shellCommand;
	shellCommand.start("reboot");
	shellCommand.waitForFinished();
}

void App::shutdown() {
	QProcess shellCommand;
	shellCommand.start("shutdown");
	shellCommand.waitForFinished();
}

void App::checkPower() {
	mmapGpio* rpiGpio = mmapGpio::getInstance();

	if(rpiGpio->readPin(ACC_PIN) == 1) { //acc off
		if(rpiGpio->readPin(SCREEN_POWER_PIN) == 1) { //screen is on
			if(!this->screenOffTimer->isActive()) {
				this->screenOnTimer->stop();
				this->screenOffTimer->start(10000);
			}
	   }
	}
	else {
		if(rpiGpio->readPin(SCREEN_POWER_PIN) == 0) { //screen is off
			if(!this->screenOnTimer->isActive()) {
				this->screenOffTimer->stop();
				this->screenOnTimer->start(10);
			}
		}
	}
}

void App::screenOn() {
	mmapGpio::getInstance()->writePinHigh(SCREEN_POWER_PIN);
}

void App::screenOff() {
	mmapGpio::getInstance()->writePinLow(SCREEN_POWER_PIN);
}

void App::setDate(QString date) {
	QProcess shellCommand;
	shellCommand.start("date --set \"" + date + "\"");
	shellCommand.waitForFinished();
	shellCommand.start("hwclock -wu");
	shellCommand.waitForFinished();
}

void App::selectLanguage(QString lang) {
	QLocale::setDefault(QLocale(lang));

	qApp->removeTranslator(translator);
	qDebug() << "lang loading" << lang << QLocale().uiLanguages();
	if(translator->load(QLocale(), "app", "_", ":/")) {
		qDebug() << "lang loaded";
		qApp->installTranslator(translator);
	}

	emit languageChanged();
}