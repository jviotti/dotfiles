#!/bin/sh

set -o errexit
set -o nounset

if [ -x "/opt/homebrew/bin/msmtp" ]
then
  MSMTP="/opt/homebrew/bin/msmtp"
elif [ -x "/usr/local/bin/msmtp" ]
then
  MSMTP="/usr/local/bin/msmtp"
elif [ -x "/usr/bin/msmtp" ]
then
  MSMTP="/usr/bin/msmtp"
else
  echo "Could not locate msmtp" 1>&2
  exit 1
fi

if [ -x "/Applications/Proton Mail Bridge.app/Contents/MacOS/bridge" ]
then
  PROTON_BRIDGE="/Applications/Proton Mail Bridge.app/Contents/MacOS/bridge"
fi

if [ -n "$PROTON_BRIDGE" ]
then
  "$PROTON_BRIDGE" --noninteractive --log-level info --log-smtp &
  BRIDGE_PID="$!"
  trap "kill $BRIDGE_PID" EXIT
fi

# Retry a few times until the bridge accepts our connections
TIMES=0
while true
do
  "$MSMTP" "$@" && CODE="$?" || CODE="$?"
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

