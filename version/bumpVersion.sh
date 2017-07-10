#!/bin/sh
#
# Template bumpVerion file from Milo Solutions. Copyright 2016.
#
# Use this script to bump version of application to a new value.
# This script will update version strings for Android, Mac OS X, 
# iOS, and Windows versions. 

echo Default bumpVersion.sh file. Please open it up and check.
echo See variables in this script: some of them are probably not needed 
echo in your project.
echo Then remove this message. Exiting!
exit

TEMPLATE_PROJECT_NAME=""

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo Usage: bumpVersion.sh [VERSION] [--increment] [--sha] [--commit]
  echo Bump version number on all platforms. Use on Unix-like operating systems.
  echo Please verify with git diff before commiting.
  echo
  echo VERSION should be something like: 1.2.3
  echo Other formats are not supported!
  exit
fi

VERSION=${1}

if [ "$VERSION" = "" ]; then
  echo "No version inserted! Please check -h for usage example."
  exit
fi

if [ "$TEMPLATE_PROJECT_NAME" = "" ]; then
  DOXYGEN_FILE="$(find ./ -maxdepth 1 -name "*.doxyfile")"
  PRO_FILE="$(find ./ -maxdepth 1 -name "*.pro")"
  WINDOWS_RC_FILE_PATH="$(find ./ -maxdepth 1 -name "*.rc")"
  NSIS_PATH="$(find ./ -maxdepth 1 -name "*.nsi")"
else
# Searchin files in directory with extensions
  DOXYGEN_FILE="$TEMPLATE_PROJECT_NAME.doxyfile"
  PRO_FILE="$TEMPLATE_PROJECT_NAME.pro"
  WINDOWS_RC_FILE_PATH="$TEMPLATE_PROJECT_NAME.rc"
  NSIS_PATH="$TEMPLATE_PROJECT_NAME.nsi"
fi
ANDROID_MANIFEST_PATH="AndroidManifest.xml"
MACOSX_PATH="Info.plist"
IOS_PATH="Info.plist"

COMMIT=false
# Function for incrementing version number
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
  echo -e "${new// /.}"
} 

for var in "$@"
do
  # incrementing added version
  if [ "$var" = "-i" ] || [ "$var" = "--increment" ]; then
    increment_version $VERSION
	exit
  # Adding commit SHA to file
  elif [ "$var" = "--sha" ]; then
	COMMIT_SHA="$(git -C "$DIR" rev-parse @)"
    echo "const char *GIT_COMMIT_ID = \"$COMMIT_SHA\";" > "version.cpp"
    echo "const char *GIT_APP_VERSION = \"$(git -C "$DIR" describe --long)\";" >> "version.cpp"
    echo "const char *GIT_APP_VERSION_SHORT = \"$(git -C "$DIR" describe --abbrev=0)\";" >> "version.cpp"  
  # Commiting changes
  elif [ "$var" = "-c" ] || [ "$var" = "--commit" ]; then
	COMMIT=true
  else
   :
  fi
done

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

# Commiting changes if -c was added
if $COMMIT ; then
  echo Done. Commiting changes...
  echo "$(git add --all)"
  echo "$(git commit -m "Bump to version $VERSION")"
else
  echo Done. Please check if everything is correct using \"git diff\", then commit as usual.
fi
