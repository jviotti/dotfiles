#!/bin/sh

set -o errexit
set -o nounset

if [ -x "/Applications/Proton Mail Bridge.app/Contents/MacOS/bridge" ]
then
  PROTON_BRIDGE="/Applications/Proton Mail Bridge.app/Contents/MacOS/bridge"
fi

if [ -n "$PROTON_BRIDGE" ]
then
  "$PROTON_BRIDGE" --noninteractive --log-level info --log-imap all &
  BRIDGE_PID="$!"
  trap "kill $BRIDGE_PID" EXIT
fi

# Go to a safe location before fetching e-mail. On i.e. WSL, `mbsync`
# will fail if it runs on a Windows directory vs a WSL directory.
cd "$HOME"

# Retry a few times until the bridge accepts our connections
TIMES=0
while true
do
  mbsync --all && CODE="$?" || CODE="$?"
  if [ "$CODE" = "0" ]
  then
    exit 0
  fi

  TIMES=$((TIMES + 1))
  if [ "$TIMES" -ge "10" ]
  then
    echo "Tried $TIMES times, aborting" 1>&2
    exit "$CODE"
  fi

  echo "Retrying..." 1>&2
  sleep 2
done

