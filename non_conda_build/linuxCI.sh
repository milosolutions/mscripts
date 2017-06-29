#!/bin/sh
#  build.sh qmake_path app_dest_dir pro_file_path release_dir_path
QMAKE_BIN_PATH=/home/tools/Qt/5.5/gcc_64/bin
APP_EXE_DESTINATION=/tmp/template-build
PROJECT_FILE=../template.pro
RELEASE_DIR_PATH=release

scripts/non_conda_build/build.sh  $QMAKE_BIN_PATH $APP_EXE_DESTINATION $PROJECT_FILE $RELEASE_DIR_PATH

