#!/bin/sh

set -o errexit
set -o nounset

if [ -x "$(command -v w3m)" ]
then
  exit 0
fi

HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1 \
  brew install w3m
