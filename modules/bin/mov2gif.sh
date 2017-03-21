#!/bin/sh

# From https://gist.github.com/dergachev/4627207

set -u
set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <mov> <output.gif>" 1>&2
  exit 1
fi

ARGV_MOV="$1"
ARGV_GIF="$2"

# Notes on the arguments:
#
# - `-r 10` tells ffmpeg to reduce the frame rate from 25 fps to 10
# - `-s 600x400` tells ffmpeg the max-width and max-height
# - `--delay=3` tells gifsicle to delay 30ms between each gif
# - `--optimize=3` requests that gifsicle use the slowest/most file-size optimization 

ffmpeg -i "$ARGV_MOV" -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > "$ARGV_GIF"
