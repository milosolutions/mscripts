@ECHO OFF

set DIR=%~dp0
FOR /F "delims=" %%I IN ('git -C %DIR% rev-parse @')          DO set COMMIT_ID=%%I
Powershell.exe -executionpolicy remotesigned -File replaceString.ps1 %DIR%\versiongit.cpp.sample "GIT_COMMIT_ID =.*" "GIT_COMMIT_ID = QByteArray(\"%COMMIT_ID%\");"
MOVE %DIR%\versiongit.cpp.sample.tmp %DIR%\versiongit.cpp
