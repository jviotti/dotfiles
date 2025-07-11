#!/bin/sh

set -o errexit
set -o nounset

DIRECTORY="$HOME/Filen"
# See https://github.com/FilenCloudDienste/filen-cli
npx @filen/cli@0.0.30 sync "$DIRECTORY:cloudToLocal:/" --verbose
