INCLUDEPATH += $${PWD}

HEADERS += $${PWD}/version.h
SOURCES += $${PWD}/version.cpp $$PWD/versiongit.cpp

DEFINES += VERSION

versionTarget.target = $${PWD}/version.h
versionTarget.depends = FORCE
win32 {
   win32-g++ {
      versionTarget.commands = $${PWD}/version.bat
   } else {
      versionTarget.commands = call $${PWD}/version.bat
   }
} else {
    versionTarget.commands = sh $${PWD}/version.sh
}
PRE_TARGETDEPS += $${PWD}/version.h
QMAKE_EXTRA_TARGETS += versionTarget

DEPENDPATH = $${PWD}/version.h
