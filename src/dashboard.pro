TEMPLATE = app
TARGET = dashboard
VERSION = 1.3
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
INCLUDEPATH += .
QT += quick serialbus multimedia multimediawidgets quickcontrols2
CONFIG += sdk_no_version_check

SOURCES += \
    main.cpp \
    can.cpp \
    mmapgpio.cpp \
    app.cpp

RESOURCES += \
    dashboard.qrc

target.path = /opt
INSTALLS += target

HEADERS += \
    can.h \
    mmapgpio.h \
    app.h

TRANSLATIONS += \
    app_en.ts \
    app_uz.ts

DISTFILES += \
    app_en.qm \
    app_en.ts \
    app_uz.qm \
    app_uz.ts
