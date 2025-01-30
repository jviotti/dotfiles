#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <url>"
fi

if ! stdsh_has_command "yt-dlp"
then
  echo "Download yt-dlp from https://github.com/yt-dlp/yt-dlp" 1>&2
  exit 1
fi

yt-dlp --extract-audio --audio-format mp3 "$1"
