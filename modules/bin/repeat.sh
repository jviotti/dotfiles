#!/bin/sh

COMMAND="$*"
TIMES=0

if [ -z "$COMMAND" ]; then
  echo "Usage: $0 <command...>" 1>&2
  exit 1
fi

info () {
  echo "\nRan $TIMES times"
  exit 0
}

trap 'info' SIGINT

while true
do
  echo "Running ($TIMES): $COMMAND"
  $COMMAND
  EXIT_CODE="$?"
  ((TIMES+=1))
  if [ "$EXIT_CODE" != "0" ]
  then
    echo "Command failed with exit code: $EXIT_CODE" 1>&2
    echo "After $TIMES retries" 1>&2
    exit "$EXIT_CODE"
  fi
done
