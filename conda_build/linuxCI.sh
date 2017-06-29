#!/bin/sh
#  build.sh channel login password qmake_path pro_file_path
BINSTAR_CHANNEL=template
LOGIN=milo
PASSWORD=milo1024
QMAKE_PATH=/home/tools/Qt/5.5/gcc_64/bin/qmake
PROJECT_FILE=../../template.pro

scripts/conda_build/build.sh $BINSTAR_CHANNEL $LOGIN $PASSWORD $QMAKE_BIN_PATH $PROJECT_FILE

