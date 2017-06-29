#!/bin/bash

# Assumes project's root as working directory

# bash flags: (-e) Stop executing on first error and (-x) show executed commands
# set -e -x

# usage:
# prepare_env.sh platform channel

platform=$1
channel=$2

if [ -z $platform ]
then
	echo "Please specify the platform for the environment"
	exit 2
fi

export env_dir=$(pwd)/build/conda/$platform
binstar_channel=$channel

packages_file=build/conda/packages.txt 

if [ -e $env_dir ] 
then
  conda update \
	--file $packages_file \
    --prefix $env_dir \
	--mkdir \
	--yes \
	--all \
	--channel $binstar_channel
else
	conda create \
	--file $packages_file \
    --prefix $env_dir \
	--mkdir \
	--yes \
	--channel $binstar_channel
fi

kernel="$(expr substr $(uname -s) 1 10)"
if [[ ! $kernel == *"NT"* ]] 
then
   source activate $env_dir
   export SP_DIR=$(python -c 'import site; print(site.getsitepackages()[0])')
fi

