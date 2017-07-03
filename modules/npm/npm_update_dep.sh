#!/bin/sh

source "$HOME/.std.sh"

if [ "$#" -ne 2 ]; then
  stdsh_fail "Usage: $0 <name> <version>"
fi

ARGV_NAME="$1"
ARGV_VERSION="$2"

if [ ! -f "$PWD/package.json" ]; then
  stdsh_fail "This doesn't look like a node project"
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
