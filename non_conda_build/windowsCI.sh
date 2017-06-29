@echo off

set QMAKE_BIN_PATH=C:\Qt\5.5\mingw492_32\bin
set MAKE_BIN_DIR=C:\Qt\Tools\mingw492_32\bin
set MAKE_COMMAND=mingw32-make.exe
set PROJECT_FILE=..\template.pro
set PACKAGE_DIR=%TEMP%\template-build
set EXE_DIR=release
set EXE_NAME=template.exe

call scripts/non_conda_build/build.bat %QMAKE_BIN_PATH% %MAKE_BIN_DIR% %MAKE_COMMAND% %PROJECT_FILE% %PACKAGE_DIR% %EXE_DIR% %EXE_NAME%
