INCLUDEPATH += $${PWD}

HEADERS += $${PWD}/version.h
SOURCES += $${PWD}/version.cpp $$PWD/versiongit.cpp

OTHER_FILES += .gitignore \
    bumpVersion.sh \
    bumpVersion.bat \
    README.md \
    replaceString.ps1 \
    version.bat \
    version.sh \
    versiongit.cpp.sample

DEFINES += VERSION

versionTarget.target = $${PWD}/versiongit.cpp
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
PRE_TARGETDEPS += $${PWD}/versiongit.cpp
QMAKE_EXTRA_TARGETS += versionTarget

DEPENDPATH = $${PWD}
