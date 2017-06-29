#!/bin/bash

channel=$1
login=$2
password=$3
qmake_path=$4
project_path=$5

export PATH=/home/tools/anaconda/bin:$PATH

echo $PWD
conda install anaconda-client -y
anaconda logout
anaconda login --username $login --password $password

source ssconda/posix/prepare_env.sh current_platform $channel

export TMPDIR=/tmp

$qmake_path $project_path
make -j`nproc`
