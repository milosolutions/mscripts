set DIR=%~dp0

FOR /F "delims=" %%I IN ('git -C %DIR% rev-parse @')          DO set COMMIT_ID=%%I
FOR /F "delims=" %%I IN ('git -C %DIR% describe --long')      DO set APP_VERSION=%%I
FOR /F "delims=" %%I IN ('git -C %DIR% describe --abbrev^=0') DO set APP_VERSION_SHORT=%%I

echo const char *GIT_COMMIT_ID = "%COMMIT_ID%"; > "%1"
echo const char *GIT_APP_VERSION = "%APP_VERSION%"; >> "%1"
echo const char *GIT_APP_VERSION_SHORT = "%APP_VERSION_SHORT%"; >> "%1"


