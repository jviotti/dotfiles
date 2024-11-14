#!/bin/sh

set -o errexit
set -o nounset

# Go to a safe location before fetching e-mail. On i.e. WSL, `mbsync`
# will fail if it runs on a Windows directory vs a WSL directory.
cd "$HOME"

exec mbsync --all
