set VCVARS=%1
set LOGIN=%2
set PASSWORD=%3
set LNK_PATH=%4
set ENVDIR=%5
set QMAKE_PATH=%6
set PROJECT_PATH=%7

call %VCVARS% 

conda install anaconda-client -y
anaconda logout
anaconda login --username %LOGIN% --password %PASSWORD%

%LNK_PATH%
SET ENV_DIR=%ENVDIR%
%QMAKE_PATH% %PROJECT_PATH%
nmake
