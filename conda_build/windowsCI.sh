@echo off

set VCVARS="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
set LOGIN=milo
set PASSWORD=milo1024
set LNK_PATH=scripts\conda_build\ssconda\windows\project_env_Win64.lnk
set ENVDIR=%CD%
set QMAKE_BIN_PATH=C:\Qt\5.5\mingw492_32\bin\qmake.exe
set PROJECT_FILE=..\..\template.pro

call scripts/conda_build/build.bat %VCVARS% %LOGIN% %PASSWORD% %LNK_PATH% %ENVDIR% %QMAKE_BIN_PATH% %PROJECT_FILE%
