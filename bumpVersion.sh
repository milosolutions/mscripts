#!/bin/sh
#
# Template bumpVerion file from Milo Solutions. Copyright 2016.
#
# Use this script to bump version of application to a new value.
# This script will update version strings for Android, Mac OS X, 
# iOS, and Windows versions. 

echo Default bumpVersion.sh file. Please open it up and check.
echo See variables in this script: some of them are probably not needed in your
echo project.
echo Then remove this message. Exiting!
exit

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo Usage: bumpVersion.sh VERSION
  echo Bump version number on all platforms. Use on Unix-like operating systems.
  echo Please verify with git diff before commiting.
  echo
  echo VERSION should be something like: 1.2.3
  echo Other formats are not supported!
  exit
fi

VERSION=${1}
DOXYGEN_FILE="template.doxyfile"
PRO_FILE="template.pro"
ANDROID_MANIFEST_PATH="AndroidManifest.xml"
WINDOWS_RC_FILE_PATH="template.rc"
NSIS_PATH="template.nsi"
MACOSX_PATH="Info.plist"
IOS_PATH="Info.plist"

#doxygen
sed -i "s/^PROJECT_NUMBER = .*/PROJECT_NUMBER = $VERSION/" $DOXYGEN_FILE

# qmake
sed -i "s/^VERSION=.*/VERSION=$VERSION/" $PRO_FILE

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

echo Done. Please check if everything is correct using \"git diff\", then commit as usual.
