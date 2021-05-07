#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <url>"
fi

youtube-dl --extract-audio --audio-format mp3 "$1"
