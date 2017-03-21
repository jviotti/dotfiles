#!/bin/sh

# Publish a package to npm
# Run this script after updating the version in
# package.json and potentially editing the README

set -u
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <profile>" 1>&2
  exit 1
fi

ARGV_PROFILE=$1
PACKAGE_VERSION=`node -e "console.log(require('./package.json').version)"`

if [ -z $PACKAGE_VERSION ]; then
  echo "package.json version value missing"
  exit 1
fi

git add . 
git commit -m "v$PACKAGE_VERSION"
git tag -s -a $PACKAGE_VERSION -m "v$PACKAGE_VERSION"
git push
git push --tags

npm_run.sh $ARGV_PROFILE publish
