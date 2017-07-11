@ECHO OFF

set DIR=%~dp0
FOR /F "delims=" %%I IN ('git -C %DIR% rev-parse @')          DO set COMMIT_ID=%%I
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %DIR%\version.cpp "GIT_COMMIT_ID =.*" "GIT_COMMIT_ID = \"%COMMIT_ID%\";"
MOVE %DIR%\version.cpp.tmp %DIR%\version.cpp