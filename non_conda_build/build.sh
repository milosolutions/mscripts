#!/bin/bash
#
# Milo Solutions @ 2015
#
#This script is intended to run on CI linux runner machine
#Machine must have make and Qt installed
#Run script only from main repo directory

#Usage:
#  build.sh qmake_path app_dest_dir pro_file_path release_dir_path

#------------------------------------

QMAKE_BIN_PATH=$1 #qmake bin path
DEST_DIR=$2 # app exe destination dir
PRO_FILE=$3 # qtcreator project file path
RELEASE_DIR=$4 # path where exe was generated

#create temp dir outside repo 
mkdir -p $DEST_DIR

#Do build in build subdirectory (CI deletes it automatically at the beginning of each job)
mkdir build
cd build
$QMAKE_BIN_PATH/qmake $PRO_FILE
make -j4

#move binary to package directory (replace if exist)
mv -f $RELEASE_DIR $DEST_DIR
