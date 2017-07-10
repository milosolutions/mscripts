@echo OFF

echo Default bumpVersion.sh file. Please open it up and check.
echo See variables in this script: some of them are probably not needed 
echo in your project.
echo Then remove this message. Exiting!
EXIT /B

set TEMPLATE_PROJECT_NAME=default
set VERSION=%1

if "%VERSION%" == "" goto no_argument_error
if "%TEMPLATE_PROJECT_NAME%" == "" goto no_name_error

if %1% == -h goto help
if %1% == --help goto help

set DOXYGEN_FILE=%TEMPLATE_PROJECT_NAME%.doxyfile
set PRO_FILE=%TEMPLATE_PROJECT_NAME%.pro
set WINDOWS_RC_FILE_PATH=%TEMPLATE_PROJECT_NAME%.rc
set NSIS_PATH=%TEMPLATE_PROJECT_NAME%.nsi
set ANDROID_MANIFEST_PATH=AndroidManifest.xml
set MACOSX_PATH=Info.plist
set IOS_PATH=Info.plist

set COMMIT=false

FOR %%a IN (%*) DO (
  IF /I "%%a"=="--sha" goto add_sha
  :after_sha
  IF /I "%%a"=="-c" set COMMIT=true
  IF /I "%%a"=="-commit" set COMMIT=true
)

REM doxygen
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %DOXYGEN_FILE% "PROJECT_NUMBER = .*" "PROJECT_NUMBER = %VERSION%"
MOVE %DOXYGEN_FILE%_tmp %DOXYGEN_FILE%

REM qmake
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %PRO_FILE% "^VERSION=.*" "VERSION=%VERSION%"
MOVE %PRO_FILE%_tmp %PRO_FILE%

REM Android:
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %ANDROID_MANIFEST_PATH% "android:versionName=\"[A-Za-z0-9_\.]*\"" "android:versionName=\"%VERSION%\""
MOVE %ANDROID_MANIFEST_PATH%_tmp %ANDROID_MANIFEST_PATH%

REM Mac OS X
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %MACOSX_PATH% "<string>[0-9]*\.[0-9]*\.[0-9]*</string>" "<string>%VERSION%</string>"
MOVE %MACOSX_PATH%_tmp %MACOSX_PATH%

REM iOS
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %IOS_PATH% "<string>[0-9]*\.[0-9]*\.[0-9]*</string>" "<string>%VERSION%</string>"
MOVE %IOS_PATH%_tmp %IOS_PATH%

REM Windows:
set RC_VER=%VERSION:.=,%
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %WINDOWS_RC_FILE_PATH% "^        FILEVERSION .*" "        FILEVERSION %RC_VER%"
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %WINDOWS_RC_FILE_PATH%_tmp "^        PRODUCTVERSION .*" "        PRODUCTVERSION %RC_VER%"
MOVE %WINDOWS_RC_FILE_PATH%_tmp %WINDOWS_RC_FILE_PATH%

REM commiting after changes
if %COMMIT% == true goto commit

EXIT /B

REM ==== FUNCTIONS =====

:commit
	git add --all
	git commit -m "Bump to version %VERSION%"
exit /B

:add_sha
set DIR=%~dp0

FOR /F "delims=" %%I IN ('git -C %DIR% rev-parse @')          DO set COMMIT_ID=%%I
FOR /F "delims=" %%I IN ('git -C %DIR% describe --long')      DO set APP_VERSION=%%I
FOR /F "delims=" %%I IN ('git -C %DIR% describe --abbrev^=0') DO set APP_VERSION_SHORT=%%I

echo const char *GIT_COMMIT_ID = "%COMMIT_ID%"; > "%1"
echo const char *GIT_APP_VERSION = "%APP_VERSION%"; >> "%1"
echo const char *GIT_APP_VERSION_SHORT = "%APP_VERSION_SHORT%"; >> "%1"
goto after_sha

:no_name_error
echo(
echo No template project name inserted!
exit /B

:no_argument_error
echo(
echo No version inserted! Please check -h for usage example.
exit /B

:help
echo(
echo Usage: bumpVersion.sh [VERSION] [--increment] [--sha] [--commit]
echo Bump version number on all platforms. Use on Unix-like operating systems.
echo Please verify with git diff before commiting.
echo(
echo VERSION should be something like: 1.2.3
echo Other formats are not supported!
exit /B
