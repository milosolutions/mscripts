@echo OFF

set TEMPLATE_PROJECT_NAME=
set VERSION=%1

echo Default bumpVersion.sh file. Please open it up and check.

if %1% == -h goto help
if %1% == --help goto help
if "%TEMPLATE_PROJECT_NAME%" == "" (
	echo See variables in this script: some of them are probably not needed 
	echo in your project.
	echo Then remove this message. Exiting!
	EXIT /B
)
if "%VERSION%" == "" (
	echo(
	echo No version inserted! Please check -h for usage example.
	exit /B
)

set DOXYGEN_FILE=%TEMPLATE_PROJECT_NAME%.doxyfile
set PRO_FILE=%TEMPLATE_PROJECT_NAME%.pro
set WINDOWS_RC_FILE_PATH=%TEMPLATE_PROJECT_NAME%.rc
set NSIS_PATH=%TEMPLATE_PROJECT_NAME%.nsi
set ANDROID_MANIFEST_PATH=AndroidManifest.xml
set MACOSX_PATH=Info.plist
set IOS_PATH=Info.plist

set COMMIT=false
set SHA=false

FOR %%a IN (%*) DO (
  IF /I "%%a"=="--sha" set SHA=true
  IF /I "%%a"=="-c" set COMMIT=true
  IF /I "%%a"=="-commit" set COMMIT=true
)


REM doxygen
if exist %DOXYGEN_FILE% (
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %DOXYGEN_FILE% "PROJECT_NUMBER = .*" "PROJECT_NUMBER = %VERSION%"
	MOVE %DOXYGEN_FILE%.tmp %DOXYGEN_FILE%
)

REM qmake
if exist %PRO_FILE% (
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %PRO_FILE% "^VERSION=.*" "VERSION=%VERSION%"
	MOVE %PRO_FILE%.tmp %PRO_FILE%
)

REM Android:
if exist %ANDROID_MANIFEST_PATH% (
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %ANDROID_MANIFEST_PATH% "android:versionName=\"[A-Za-z0-9_\.]*\"" "android:versionName=\"%VERSION%\""
	MOVE %ANDROID_MANIFEST_PATH%.tmp %ANDROID_MANIFEST_PATH%
)

REM Mac OS X
if exist %MACOSX_PATH% (
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %MACOSX_PATH% "<string>[0-9]*\.[0-9]*\.[0-9]*</string>" "<string>%VERSION%</string>"
	MOVE %MACOSX_PATH%.tmp %MACOSX_PATH%
)

REM iOS
if exist %IOS_PATH% (
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %IOS_PATH% "<string>[0-9]*\.[0-9]*\.[0-9]*</string>" "<string>%VERSION%</string>"
	MOVE %IOS_PATH%.tmp %IOS_PATH%
)

REM Windows:
if exist %WINDOWS_RC_FILE_PATH% (
	set RC_VER=%VERSION:.=,%
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %WINDOWS_RC_FILE_PATH% "^        FILEVERSION .*" "        FILEVERSION %RC_VER%"
	Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %WINDOWS_RC_FILE_PATH%.tmp "^        PRODUCTVERSION .*" "        PRODUCTVERSION %RC_VER%"
	MOVE %WINDOWS_RC_FILE_PATH%.tmp.tmp %WINDOWS_RC_FILE_PATH%
)

REM commiting after changes
if %COMMIT% == true (
	git add --all
	git commit -m "Bump to version %VERSION%"
)

if %SHA% == true call version.bat

EXIT /B

REM ==== FUNCTIONS =====

:help
echo(
echo Usage: bumpVersion.sh [VERSION] [--sha] [--commit/-c]
echo Need to be run from project directory!
echo(
echo Bump version number on all platforms. Use on Unix-like operating systems.
echo Please verify with git diff before commiting.
echo(
echo VERSION should be something like: 1.2.3
echo Other formats are not supported!
exit /B