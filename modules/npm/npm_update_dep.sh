#!/bin/sh

set -e
set -u

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <name> <version>" 1>&2
  exit 1
fi

ARGV_NAME="$1"
ARGV_VERSION="$2"

if [ ! -f "$PWD/package.json" ]; then
  echo "This doesn't look like a node project" 1>&2
  exit 1
fi

echo "Upgrading $ARGV_NAME to $ARGV_VERSION"

# Do everything from scratch if there is a shrinkwrap file
if [ -f "$PWD/npm-shrinkwrap.json" ]; then
  rm -rf node_modules
  npm install --build-from-source
fi

npm install --save "$ARGV_NAME@$ARGV_VERSION"
git add package.json

if [ -f "$PWD/npm-shrinkwrap.json" ]; then
  git checkout -- npm-shrinkwrap.json
  npm prune --production
  npm shrinkwrap
  git add npm-shrinkwrap.json
fi
