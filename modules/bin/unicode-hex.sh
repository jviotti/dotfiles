#!/bin/sh

source "$HOME/.std.sh"

# For when icu4c is installed through brew
stdsh_path_add "/usr/local/opt/icu4c/bin"

stdsh_dependency_check "hexdump"
stdsh_dependency_check "uconv"

usage() {
  echo "Usage: $0 [OPTIONS] <string>"
  echo ""
  echo "Options"
  echo ""
  echo "    -n normalize string"
  exit 1
}

ARGV_NORMALIZE="$STDSH_CONSTANT_FALSE"

while getopts ":n" option; do
  case $option in
    n) ARGV_NORMALIZE="$STDSH_CONSTANT_TRUE" ;;
    *) usage ;;
  esac
done

shift $((OPTIND-1))
set +u
ARGV_INPUT="$1"
set -u

if stdsh_is_undefined "$ARGV_INPUT"; then
  usage
fi

TRANSLITERATION="$(stdsh_if_expression "$ARGV_NORMALIZE" any-nfd any-nfc)"
echo "$ARGV_INPUT" | uconv -x "$TRANSLITERATION" | hexdump
