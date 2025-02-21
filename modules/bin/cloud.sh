#!/bin/sh

set -o errexit
set -o nounset

DIRECTORY="$HOME/Filen"
# See https://github.com/FilenCloudDienste/filen-cli
npx @filen/cli sync "$DIRECTORY:cloudToLocal:/" --verbose
