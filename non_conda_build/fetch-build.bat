@echo off
setlocal EnableDelayedExpansion

call :CONFIG DIR_ROOT_MSVS
call :CONFIG DIR_BIN_QMAKE
call :CONFIG DIR_BIN_NSIS
call :CONFIG GIT_REPOSITORY
call :CONFIG ARCH
call :CONFIG DISTDIR
call :CONFIG PROJECT_NAME

echo Build dir cleanup...
rmdir /Q /S build source
rem del /Q /S /F "other files"

echo Fetching repository...
git clone "%GIT_REPOSITORY%" source || (echo Failed to fetch repository && exit /B)
FOR /F "delims=" %%I in ('git -C source describe --long') DO set GIT_VERSION=%%I

echo Building project...
mkdir build
cd build
set PATH=%DIR_BIN_QMAKE%;%DIR_BIN_NSIS%;%PATH%
call "%DIR_ROOT_MSVS%\VC\vcvarsall.bat" %ARCH%  || (echo Failed to setup Microsoft Visual Studio compiler && exit /B)
qmake CONFIG+=release -r ..\source              || (echo Failed qmake configuration && exit /B)
nmake                                           || (echo Failed build phase && exit /B)
nmake install                                   || (echo Failed install phase && exit /B)
cd ..

echo Deploying Qt libraries...
windeployqt --compiler-runtime build\%DISTDIR% || (echo Failed to deploy Qt libraries && exit /B)

echo Assembling installer...
makensis /DDIR=build\%DISTDIR% /DPROJECT_NAME=%PROJECT_NAME% installer.nsi

endlocal

rem Start of local helper functions.
goto :EOF

rem usage: call :TRIM "    a  value with trailing spaces    "
rem just removes trailing spaces. Result is value without trailing spaces returned in TRIMMED variable
:TRIM
set TRIMMED=%*
goto :EOF

rem usage: call :CONFIG KEY VARIABLE
rem result is VARIABLE has been assigned with value from config file specified by KEY
:CONFIG
set %1=
FOR /F "delims== tokens=1,*" %%I IN ( %~dpn0.config ) DO (
	call :TRIM %%I
	if "!TRIMMED!" == "%1" (
		call :TRIM %%J
		set %1=!TRIMMED!
		goto :EOF
	)
)
goto :EOF
