INCLUDEPATH += $${PWD}

VERSION_DEPEND = $${PWD}/../.git   # path to git directory in project
win32 {
   win32-g++ {
      version_compiler.commands = $${PWD}/version.bat
   } else {
      version_compiler.commands = call $${PWD}/version.bat
   }
} else {
    version_compiler.commands = $${PWD}/version.sh
}
version_compiler.input = VERSION_DEPEND
version_compiler.CONFIG = target_predeps no_link
version_compiler.variable_out = SOURCES
QMAKE_EXTRA_COMPILERS += version_compiler
