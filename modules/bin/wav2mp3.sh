#!/bin/sh

set -e
source "$HOME/.std.sh"

stdsh_dependency_check "ffmpeg"

set +u
ARGV_INPUT="$1"
set -u

usage() {
  echo "Usage: $0 <input>" 1>&2
  exit 1
}

if stdsh_is_undefined "$ARGV_INPUT"; then
  usage
fi

ffmpeg -i "$ARGV_INPUT" -acodec mp3 "$(basename "$ARGV_INPUT" .wav).mp3"
