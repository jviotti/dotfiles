#!/bin/bash

set -e
set -u

function usage() {
  echo "Run sed in-place"
  echo ""
  echo "Usage: $0 [OPTIONS] <files>"
  echo ""
  echo "Options"
  echo ""
  echo "    -f <script>"
  echo "    -e <command>"
  exit 1
}

ARGV_SCRIPT=""
ARGV_COMMAND=""

while getopts ":f:e:" option; do
  case $option in
    f) ARGV_SCRIPT=$OPTARG ;;
    e) ARGV_COMMAND=$OPTARG ;;
    *) usage ;;
  esac
done

shift $(expr $OPTIND - 1)

if [ "$#" -eq 0 ]; then
  usage
fi

FILES=$@

if [ -z "$ARGV_SCRIPT" ] && [ -z "$ARGV_COMMAND" ]; then
  usage
fi

if [ -n "$ARGV_SCRIPT" ] && [ -n "$ARGV_COMMAND" ]; then
  echo "-f and -c are mutually exclusive" 1>&2
  exit 1
fi

TEMPORARY_FILE=$(mktemp)

function cleanup() {
  rm -f "$TEMPORARY_FILE"
}

trap "cleanup" ERR
trap "cleanup" EXIT

for file in $FILES; do

  if [ -n "$ARGV_SCRIPT" ]; then
    sed -f "$ARGV_SCRIPT" "$file" > "$TEMPORARY_FILE"
  fi

  if [ -n "$ARGV_COMMAND" ]; then
    sed -e "$ARGV_COMMAND" "$file" > "$TEMPORARY_FILE"
  fi

  mv "$TEMPORARY_FILE" "$file"
done
