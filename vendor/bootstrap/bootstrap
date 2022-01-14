#!/bin/sh

set -o errexit
set -o nounset

DIRECTORY="${1-$PWD/bootstrap}"

UNAME="$(uname)"
if [ "$UNAME" = "Darwin" ]
then
  PLATFORM="macos"
elif [ "$UNAME" = "Linux" ]
then
  PLATFORM="linux"
elif [ "$(uname -o)" = "Msys" ]
then
  PLATFORM="windows"
elif [ "$(uname -o)" = "Cygwin" ]
then
  PLATFORM="windows"
else
  echo "Unknown platform: $UNAME" 1>&2
  exit 1
fi

run_bootstrap_script() {
  "$1" && EXIT_CODE="$?" || EXIT_CODE="$?"
  if [ "$EXIT_CODE" != "0" ]
  then
    echo "(bootstrap) ERROR: Script failed: $1" 1>&2
    exit "$EXIT_CODE"
  fi
}

run_bootstrap_directory() {
  if [ -d "$1" ]
  then
    echo "(bootstrap) Running scripts from $1" 1>&2
    for script in "$1"/*
    do
      run_bootstrap_script "$script"
    done
  fi
}

run_bootstrap_directory "$DIRECTORY/$PLATFORM"
run_bootstrap_directory "$DIRECTORY/any"
