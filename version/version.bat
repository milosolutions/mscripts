set DIR=%~dp0
FOR /F "delims=" %%I IN ('git -C %DIR% rev-parse @')          DO set COMMIT_ID=%%I
echo const char *GIT_COMMIT_ID = "%COMMIT_ID%"; > %DIR%\version.cpp