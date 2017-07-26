INCLUDEPATH += $${PWD}

HEADERS += $${PWD}/version.h
SOURCES += $${PWD}/version.cpp $${PWD}/versiongit.cpp

OTHER_FILES += $${PWD}/.gitignore \
    $${PWD}/bumpVersion.sh \
    $${PWD}/bumpVersion.bat \
    $${PWD}/README.md \
    $${PWD}/replaceString.ps1 \
    $${PWD}/version.bat \
    $${PWD}/version.sh \
    $${PWD}/versiongit.cpp.sample

DEFINES += VERSION_LIB
# for MinGW it won't see versiongit.cpp
exists($$PWD/versiongit.cpp) {
    DEFINES += VERSION_GIT
}

versionTarget.target = $${PWD}/versiongit.cpp
versionTarget.depends = FORCE
win32 {
    !exists($$PWD/versiongit.cpp) {
        system(copy versiongit.cpp.sample versiongit.cpp)
    }
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
