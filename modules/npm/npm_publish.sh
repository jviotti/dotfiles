#!/bin/sh

# Publish a package to npm
# Run this script after updating the version in
# package.json and potentially editing the README

source "$HOME/.std.sh"

if [ "$#" -ne 1 ]; then
  stdsh_fail "Usage: $0 <profile>"
fi

ARGV_PROFILE=$1
PACKAGE_VERSION=`node -e "console.log(require('./package.json').version)"`

if stdsh_is_undefined "$PACKAGE_VERSION"; then
  stdsh_fail "package.json version value missing"
fi

git add . 
git commit -m "v$PACKAGE_VERSION"
git tag -s -a "v$PACKAGE_VERSION" -m "v$PACKAGE_VERSION"
git push
git push --tags

npm_run.sh $ARGV_PROFILE publish
