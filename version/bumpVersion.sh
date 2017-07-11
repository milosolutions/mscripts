#!/bin/bash
#
# Template bumpVerion file from Milo Solutions. Copyright 2016.
#
# Use this script to bump version of application to a new value.
# This script will update version strings for Android, Mac OS X, 
# iOS, and Windows versions. 

increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  new=${new// /.}
  VERSION=$new
} 

TEMPLATE_PROJECT_NAME=""

echo Default bumpVersion.sh file. Please open it up and check.
echo

if [ "$TEMPLATE_PROJECT_NAME" = "" ]; then
	echo
	echo See variables in this script: template project name not set
	echo Exiting!
	exit
fi

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
	echo
	echo Usage: bumpVersion.sh [VERSION] [--sha] [--commit/-c] 
	echo Need to be run from project directory!
	echo 
	echo Bump version number on all platforms. Use on Unix-like operating systems.
	echo Please verify with git diff before commiting.
	echo
	echo VERSION should be something like: 1.2.3
	echo Other formats are not supported!
	echo Exiting!
	exit
fi

if [ "$1" = "" ]; then
	echo No version inserted! Please check -h for usage example.
	echo Exiting!
	exit
fi

VERSION=${1}
DIR=$(dirname $0)

DOXYGEN_FILE="$TEMPLATE_PROJECT_NAME.doxyfile"
VERSION_FILE="$DIR/version.cpp"
WINDOWS_RC_FILE_PATH="$TEMPLATE_PROJECT_NAME.rc"
NSIS_PATH="$TEMPLATE_PROJECT_NAME.nsi"
ANDROID_MANIFEST_PATH="AndroidManifest.xml"
MACOSX_PATH="Info.plist"
IOS_PATH="Info.plist"

COMMIT=false
SHA=false

for var in "$@"
do
	# incrementing added version
	if [ "$var" = "-i" ] || [ "$var" = "--increment" ]; then
		VERSION="$(grep -F 'APP_VERSION =' version.cpp | grep -P -o '([0-9]+\.*)+')"
		if [ "$VERSION" = "" ]; then
			echo
			echo "Version found in $VERSION_FILE is empty!"
			echo Exiting!
			exit
		fi
		increment_version $VERSION
	# Adding commit SHA to file
	elif [ "$var" = "--sha" ]; then
		SHA=true
	# Commiting changes
	elif [ "$var" = "-c" ] || [ "$var" = "--commit" ]; then
		COMMIT=true
	else
		:
	fi
done

if echo $VERSION | grep -q "-" 
then
	:
else
	#doxygen
	sed -i "s/^PROJECT_NUMBER = .*/PROJECT_NUMBER = $VERSION/" $DOXYGEN_FILE

	# version.cpp
	sed -i "s/APP_VERSION =.*/APP_VERSION = \"$VERSION\";/" $VERSION_FILE

	# Android:
	sed -i "s/android:versionName=\"[A-Za-z0-9_\.]*\"/android:versionName=\"$VERSION\"/" $ANDROID_MANIFEST_PATH

	# Android: bump internal version as well, so that OS can detect
	# newer builds.
	# This sed invokation is crazy, but works. See here:
	# http://stackoverflow.com/questions/14348432/how-to-find-replace-and-increment-a-matched-number-with-sed-awk
	sed -i -r 's/"/\\"/g;s/(.*)(android:versionCode=\\")([0-9]+)(.*)/echo "\1\2$((\3+1))\4"/ge;s/\\"/"/g' $ANDROID_MANIFEST_PATH

	# Windows:
	RC_VER=$(echo "$VERSION" | tr '.' ','),0
	sed -i "s/^        FILEVERSION .*/        FILEVERSION $RC_VER/" $WINDOWS_RC_FILE_PATH
	sed -i "s/^        PRODUCTVERSION .*/        PRODUCTVERSION $RC_VER/" $WINDOWS_RC_FILE_PATH

	# NSIS scripts:
	sed -i "s/^  !define VERSION \"[A-Za-z0-9_\.]*\"/  !define VERSION \"$VERSION\"/" $NSIS_PATH

	# Mac OS X
	sed -i "s#<string>[0-9]*\.[0-9]*\.[0-9]*</string>#<string>$VERSION</string>#" $MACOSX_PATH

	# iOS
	sed -i "s#<string>[0-9]*\.[0-9]*\.[0-9]*</string>#<string>$VERSION</string>#" $IOS_PATH
fi

# Commiting changes if -c was added
if $COMMIT ; then
	echo
	echo Done. Commiting changes...
	echo "$(git add --all)"
	echo "$(git commit -m "Bump version to $VERSION")"
	echo Exiting!
else
	echo
	echo Done. Please check if everything is correct using \"git diff\", then commit as usual.
	echo Exiting!
fi

if $SHA ; then
	sh $DIR/version.sh
fi
