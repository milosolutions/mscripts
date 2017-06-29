@echo off
REM Milo Solutions @ 2015
REM
REM This script is intended to run only on windows
REM Script should be run only from main directory of repository

REM Usage:
REM  build.bat qmake_bin_path compiler_bin_path make_command_exe project_file_path destination_dir_path app_exe_path app_exe_name

REM Update all variables to your machine
REM ------------------------------------
REM qmake bin directory path
set qmake_bin_path=%1
REM path to compiler - don't use quotes, if path contains space escape space character using a backslash (\)
set compiler_bin_path=%2
REM make command exe
set make_command=%3
REM path to project file
set pro_file_path=%4
REM Path to folder where exe will be copied
set PACKAGE_DIR=%5
REM Executable location
set EXE_PATH=%6
REM Name of app executable
set APP_EXE=%7
REM ------------------------------------

REM Need to avoid conflicts with other binaries in the PATH
set PATH=%compiler_bin_path%;c:\Windows\System32

REM create package dir
if exist %PACKAGE_DIR% (
  rmdir /s /q %PACKAGE_DIR%
)
md %PACKAGE_DIR%

REM create build dir and build all in it
rmdir /s /q build_dir
md build_dir
cd build_dir
REM Run qmake
%qmake_bin_path%\qmake.exe %pro_file_path%
REM Run make
%compiler_bin_path%\%make_command% -j4

REM Copy binary to package directory (replace if exist)
copy /b/v/y %EXE_PATH%\%APP_EXE% %PACKAGE_DIR%\%APP_EXE%

