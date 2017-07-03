#!/bin/sh

set -e
set -u

usage() {
  echo "Usage: $0 [OPTIONS] <string>"
  echo ""
  echo "Options"
  echo ""
  echo "    -n normalize string"
  exit 1
}

ARGV_NORMALIZE=0

while getopts ":n" option; do
  case $option in
    n) ARGV_NORMALIZE=1 ;;
    *) usage ;;
  esac
done

shift $((OPTIND-1))
set +u
ARGV_INPUT="$1"
set -u

if [ -z "$ARGV_INPUT" ]; then
  usage
fi

# For when icu4c is installed through brew
if [ -d "/usr/local/opt/icu4c/bin" ]; then
  PATH=$PATH:/usr/local/opt/icu4c/bin
fi

if [ "$ARGV_NORMALIZE" = "1" ]; then
  TRANSLITERATION="any-nfd"
else
  TRANSLITERATION="any-nfc"
fi

echo "$ARGV_INPUT" | uconv -x "$TRANSLITERATION" | hexdump
