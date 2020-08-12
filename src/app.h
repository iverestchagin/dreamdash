#ifndef APP_H
#define APP_H

#include <QObject>
#include <QTimer>
#include <mmapgpio.h>
#include <QTranslator>
#include <can.h>

class App : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString translateTrigger READ getEmptyString NOTIFY languageChanged)

private:
	const unsigned int ACC_PIN = 6;
	const unsigned int SCREEN_POWER_PIN = 26;
	int accCounter = 0;
	QTranslator *translator;
	QTimer *screenOnTimer;
	QTimer *screenOffTimer;
	Can *can;

public:
	explicit App(Can *can, QObject *parent = nullptr);
	QString getEmptyString() {
		return "";
	}

signals:
	void languageChanged();

public slots:
	void start();
	void reboot();
	void shutdown();
	void checkPower();
	void setDate(QString date);
	void selectLanguage(QString lang);

private slots:
	void screenOn();
	void screenOff();
};

#endif // APP_H
