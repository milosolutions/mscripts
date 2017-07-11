@echo OFF

set TEMPLATE_PROJECT_NAME=

echo Default bumpVersion.sh file. Please open it up and check.
echo.

if %1% == -h goto help
if %1% == --help goto help
if "%1%" == "" (
	echo.
	echo No version inserted! Please check -h for usage example.
	EXIT /B
)
if "%TEMPLATE_PROJECT_NAME%" == "" (
	echo.
	echo See variables in this script: template project name not set
	echo Exiting!
	EXIT /B
)

set VERSION=%1
set DIR=%~dp0

REM files
set DOXYGEN_FILE=%TEMPLATE_PROJECT_NAME%.doxyfile
set VERSION_FILE=%DIR%\version.cpp
set WINDOWS_RC_FILE_PATH=%TEMPLATE_PROJECT_NAME%.rc
set NSIS_PATH=%TEMPLATE_PROJECT_NAME%.nsi
set ANDROID_MANIFEST_PATH=AndroidManifest.xml
set MACOSX_PATH=Info.plist
set IOS_PATH=Info.plist

REM commands
set COMMIT=false
set SHA=false
set INCREMENT=false

FOR %%a IN (%*) DO (
	IF /I "%%a"=="-i" set INCREMENT=true
	IF /I "%%a"=="--increment" set INCREMENT=true
	IF /I "%%a"=="--sha" set SHA=true
	IF /I "%%a"=="-c" set COMMIT=true
	IF /I "%%a"=="-commit" set COMMIT=true
)

if %INCREMENT% == true (
	goto :increment_version
	:increment_return
)

if not "%VERSION:~0,1%" == "-" (
	REM doxygen
	if exist %DOXYGEN_FILE% (
		Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %DOXYGEN_FILE% "PROJECT_NUMBER = .*" "PROJECT_NUMBER = %VERSION%"
		MOVE %DOXYGEN_FILE%.tmp %DOXYGEN_FILE%
	)

	REM version.cpp
	if exist %VERSION_FILE% (
		Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %VERSION_FILE% "APP_VERSION =.*" "APP_VERSION = \"%VERSION%\";"
		MOVE %VERSION_FILE%.tmp %VERSION_FILE%
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
)

REM commiting after changes
if %COMMIT% == true (
	git add --all
	git commit -m "Bump to version %VERSION%"
)

if %SHA% == true call version.bat

EXIT /B

REM ==== FUNCTIONS =====

:increment_version
Powershell.exe -executionpolicy remotesigned -File incrementVersion.ps1 %VERSION_FILE%
set NEW_VERSION_FILE=new_version.txt
set VERSION=
if exist %NEW_VERSION_FILE% (
	for /f "delims=" %%x in ('type %NEW_VERSION_FILE%') do set VERSION=%%x
	DEL %NEW_VERSION_FILE%
) else (
	echo Version found in %VERSION_FILE% is empty!
	echo Exiting!
	EXIT /B
)
goto :increment_return

:help
echo.
echo Usage: bumpVersion.sh [VERSION] [--sha] [--commit/-c]
echo Need to be run from project directory!
echo.
echo Bump version number on all platforms. Use on Unix-like operating systems.
echo Please verify with git diff before commiting.
echo.
echo VERSION should be something like: 1.2.3
echo Other formats are not supported!
exit /B
