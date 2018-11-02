#!/bin/sh

ARGV_COMMAND="$1"
ARGV_MODULE="$2"

set -e
set -u

DIRECTORY_MODULES="modules"
MODULES_LIST="$(ls "$DIRECTORY_MODULES" | tr '\n' ' ')"

usage () {
	echo " ______   _______  _______  _______  ___   ___      _______  _______"
	echo "|      | |       ||       ||       ||   | |   |    |       ||       |"
	echo "|  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|"
	echo "| | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ "
	echo "| |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |"
	echo "|       ||       |  |   |  |   |    |   | |       ||   |___  _____| |"
	echo "|______| |_______|  |___|  |___|    |___| |_______||_______||_______|"
	echo ""
	echo "MODULES: $MODULES_LIST"
	echo ""
	echo "Commands:"
	echo ""
	echo "  install [module]"
	echo "  uninstall [module]"
	echo "  build [module]"
  exit 1
}

template () (
  module="$1"
  file="$2"
  shift 2
  version="$*"

  for version in $version; do
    for os in darwin linux; do
      path="$module/$version/$os"
      echo "Generating $path"
      mkdir -p "$path"
      gpp \
        -o "$path/$file" \
        -DOS="$os" \
        -DVERSION="$version" \
        -U "" "" "(" "," ")" "(" ")" "\#" "\\" \
        -M "%%" "\n" " " " " "\n" "(" ")" \
        "$module/$file"
    done
  done
)

if [ -z "$ARGV_COMMAND" ]; then
  usage
fi

if [ "$ARGV_COMMAND" = "build" ]; then
  if [ -z "$ARGV_MODULE" ]; then
    usage
  fi

  if [ "$ARGV_MODULE" = "git" ]; then
    template "$DIRECTORY_MODULES/$ARGV_MODULE" "gitconfig" "2.13.0"
    exit 0
  fi

  if [ "$ARGV_MODULE" = "tmux" ]; then
    template "$DIRECTORY_MODULES/$ARGV_MODULE" "tmux.conf" "1.8" "2.4"
    exit 0
  fi

  echo "Don't know how to build $ARGV_MODULE" 1>&2
  exit 1
fi

if [ "$ARGV_COMMAND" = "install" ]; then
  ACTION="apply"
elif [ "$ARGV_COMMAND" = "uninstall" ]; then
  ACTION="revert"
else
  echo "Invalid command: $ARGV_COMMAND" 1>&2
  exit 1
fi

DOTF_OPTIONS="-a "$ACTION" -n "$DIRECTORY_MODULES" -c CONFIG"

if [ -n "$ARGV_MODULE" ]; then
  DOTF_OPTIONS="$DOTF_OPTIONS -m $ARGV_MODULE"
  ./deps/dotf/dotf.sh $DOTF_OPTIONS
else
  for module in modules/*; do
    ./deps/dotf/dotf.sh $DOTF_OPTIONS -m "$(basename "$module")"
  done
fi

