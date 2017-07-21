INCLUDEPATH += $${PWD}

HEADERS += $${PWD}/version.h
SOURCES += $${PWD}/version.cpp

DEFINES += VERSION

VERSION_DEPEND = $${PWD}/../../../.git   # path to git directory in project
win32 {
   win32-g++ {
      version_compiler.commands = $${PWD}/version.bat
   } else {
      version_compiler.commands = call $${PWD}/version.bat
   }
} else {
    version_compiler.commands = sh $${PWD}/version.sh
}
version_compiler.input = VERSION_DEPEND
version_compiler.CONFIG = target_predeps no_link
version_compiler.output = $${PWD}/version.cpp.o
QMAKE_EXTRA_COMPILERS += version_compiler
