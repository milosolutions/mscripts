#!/bin/bash

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo Usage example: installHooks.sh 4.1
  echo Installs hooks found in this folder to your local GIT checkout. Because
  echo clang-format can have different version numbers on different systems,
  echo you need to provide the suffix. You can also modify the hook manyally after
  echo running this script. The hook is located at .git/hooks/pre-commit.py.
  echo
  echo Requires git and clang-format
  exit
fi

echo Copying hooks

echo   pre-commit hook
HOOKSDIR=../../.git/hooks
cp pre-commit.py $HOOKSDIR/pre-commit

echo   Updating clang-format binary path

REPLACEMENT="clang-format-$1"

# If user specified full path, we pass it directly
if [ -x "$1"  ]; then
  echo   Full path specified, replacing...
  REPLACEMENT="$1"
elif [[ "$1" == *"-"* ]]; then
  echo   Different binary name specified, replacing...
  REPLACEMENT="$1"
fi

if [ -z "${1}" ]; then
  echo No clang-format version provided - will use just "clang-format"
  REPLACEMENT="clang-format"
fi

sed -i 's:clang-format-4.0:'"$REPLACEMENT"':' $HOOKSDIR/pre-commit
echo Done.
