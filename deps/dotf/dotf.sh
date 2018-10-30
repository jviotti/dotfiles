#!/bin/sh

# Copyright (c) 2017, Juan Cruz Viotti
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#     # derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

VERSION="0.1.0"
DRY_RUN=""

set -e
set -u

# -------------------------------------------------
# Filesystem
# -------------------------------------------------

dotf__fs_mkdirp () (
  path="$1"
  echo "Creating directory: $path"
  if [ -z "$DRY_RUN" ]
  then
    mkdir -p "$path"
  fi
)

dotf__fs_rmdir () (
  path="$1"
  echo "Removing directory if empty: $path"
  if [ -z "$DRY_RUN" ]
  then
    rmdir "$path" || true
  fi
)

dotf__fs_rm () (
  path="$1"
  echo "Removing file: $path"
  if [ -z "$DRY_RUN" ]
  then
    rm "$path"
  fi
)

dotf__fs_ln () (
  origin="$1"
  destination="$2"

  # If the destination is already a symlink to a directory,
  # then we must ensure it is removed, otherwise `ln` will
  # create symlinks inside the directory it points to instead
  # of replacing it.
  if [ -L "$destination" ] && [ -d "$destination" ]
  then
    dotf__fs_rm "$destination"
  fi

  echo "Symlinking: $origin -> $destination"
  if [ -z "$DRY_RUN" ]
  then
    ln -f -s "$origin" "$destination"
  fi
)

dotf__fs_chmod () (
  path="$1"
  mode="$2"
  echo "Changing mode: $path -> $mode"
  if [ -z "$DRY_RUN" ]
  then
    chmod "$mode" "$path"
  fi
)

# -------------------------------------------------
# Utils
# -------------------------------------------------

dotf__utils_get_absolute_path () (
  path="$1"
  current="$(pwd -P)"
  cd "$(dirname "$path")"
  absolute="$(pwd -P)"
  cd "$current"
  echo "$absolute/$(basename "$path")"
)

dotf__utils_get_column () (
  string="$1"
  column="$2"
  echo "$string" | cut -d ' ' -f "$column"
)

# Inclusive
dotf__utils_get_columns_from () (
  string="$1"
  column="$2"
  dotf__utils_get_column "$string" "$column-"
)

dotf__utils_error () (
  message="$1"
  echo "$message" 1>&2
)

dotf__utils_fail () (
  message="$1"
  dotf__utils_error "$message"
  exit 1
)

dotf__utils_os () (
  uname | tr '[:upper:]' '[:lower:]'
)

# -------------------------------------------------
# Configuration
# -------------------------------------------------

dotf_configuration_get_entry () (
  configuration="$1"
  module_name="$2"
  file_name="$3"

  # Make sure the configuration file exists before
  # trying to run grep on it.
  if [ -f "$configuration" ]
  then
    grep \
      --max-count=1 \
      "^$module_name $file_name" \
      "$configuration" \
      || true
  fi
)

dotf_configuration_find_version () (
  module="$1"
  file="$2"
  version="$3"
  os="$(dotf__utils_os)"

  # Try the OS specific location first
  if [ -f "$module/$version/$os/$file" ]
  then
    echo "$module/$version/$os/$file"
  elif [ -f "$module/$version/$file" ]
  then
    echo "$module/$version/$file"
  fi
)

# -------------------------------------------------
# Command
# -------------------------------------------------

DOTF_COMMAND_DIRECTION_APPLY="apply"
DOTF_COMMAND_DIRECTION_REVERT="revert"

dotf_command_directory () (
  direction="$1"
  module="$2"
  basedir="$3"
  configuration="$4"
  arguments="$5"

  directory="$(dotf__utils_get_column "$arguments" "1")"

  # We don't want to process directories that are just a
  # period, since means that we will generate unnecessary
  # noise by creating $basedir/., but also that we will
  # try to remove $basedir on a revert direction.
  if [ "$directory" = "." ]
  then
    return
  fi

  if [ "$direction" = "$DOTF_COMMAND_DIRECTION_APPLY" ]
  then
    dotf__fs_mkdirp "$basedir/$directory"
  elif [ "$direction" = "$DOTF_COMMAND_DIRECTION_REVERT" ]
  then
    dotf__fs_rmdir "$basedir/$directory"
  else
    dotf__utils_fail "Invalid direction: $direction"
  fi
)

dotf_command_symlink () (
  direction="$1"
  module="$2"
  basedir="$3"
  configuration="$4"
  arguments="$5"

  file="$(dotf__utils_get_column "$arguments" "1")"
  destination="$(dotf__utils_get_column "$arguments" "2")"
  mode="$(dotf__utils_get_column "$arguments" "3")"

  if [ "$direction" = "$DOTF_COMMAND_DIRECTION_APPLY" ]
  then
    dotf_command_directory \
      "$direction" \
      "$module" \
      "$basedir" \
      "$configuration" \
      "$(dirname "$destination")"

    absolute_file="$module/$file"
    configentry="$(dotf_configuration_get_entry \
      "$configuration" \
      "$(basename "$module")" \
      "$file")"
    if [ -n "$configentry" ]
    then
      version="$(dotf__utils_get_column "$configentry" "3")"
      absolute_file="$(dotf_configuration_find_version \
        "$module" \
        "$file" \
        "$version")"
      if [ -z "$absolute_file" ]
      then
        dotf__utils_fail "Couldn't find version $version of file $file in $module"
      fi
    fi

    dotf__fs_ln "$absolute_file" "$basedir/$destination"

    if [ -n "$mode" ]
    then
      dotf__fs_chmod "$basedir/$destination" "$mode"
    fi
  elif [ "$direction" = "$DOTF_COMMAND_DIRECTION_REVERT" ]
  then
    dotf__fs_rm "$basedir/$destination"
  else
    dotf__utils_fail "Invalid direction: $direction"
  fi
)

# -------------------------------------------------
# Manifest
# -------------------------------------------------

DOTF_MANIFEST_NAME="MANIFEST"
DOTF_MANIFEST_COMMAND_DIRECTORY="DIRECTORY"
DOTF_MANIFEST_COMMAND_SYMLINK="SYMLINK"

dotf_manifest_get_path () (
  module="$1"
  echo "$module/$DOTF_MANIFEST_NAME"
)

dotf_manifest_execute () (
  module="$1"
  direction="$2"
  basedir="$3"
  configuration="$4"
  manifest="$(dotf_manifest_get_path "$module")"

  while read -r line
  do
    command="$(dotf__utils_get_column "$line" "1")"
    arguments="$(dotf__utils_get_columns_from "$line" "2")"

    # A line without a command is a blank line that
    # we can safely omit
    if [ -z "$command" ]
    then
      continue
    fi

    if [ "$command" = "$DOTF_MANIFEST_COMMAND_DIRECTORY" ]
    then
      dotf_command_directory \
        "$direction" \
        "$module" \
        "$basedir" \
        "$configuration" \
        "$arguments"
    elif [ "$command" = "$DOTF_MANIFEST_COMMAND_SYMLINK" ]
    then
      dotf_command_symlink \
        "$direction" \
        "$module" \
        "$basedir" \
        "$configuration" \
        "$arguments"
    else
      dotf__utils_fail "Invalid command: $command on $module"
    fi
  done < "$manifest"
)

# -------------------------------------------------
# Module
# -------------------------------------------------

dotf_module_is_valid () (
  module="$1"
  manifest="$(dotf_manifest_get_path "$module")"
  [ -f "$manifest" ]
)

# -------------------------------------------------
# CLI
# -------------------------------------------------

ARGV_ACTION=""
ARGV_BASE_DIRECTORY=""
ARGV_CONFIGURATION=""
ARGV_MODULE=""
ARGV_NAMESPACE=""
ARGV_HELP=""
ARGV_VERSION=""

usage () {
  echo "Usage: $0 [-dhv] [-a action] [-c file] [-m directory]"
  echo "          [-n directory] [-o directory]"
  echo ""
  echo "Consult the man page for details"
  exit 0
}

while getopts ":a:c:m:n:o:dhv" option
do
  case $option in
    a) ARGV_ACTION=$OPTARG ;;
    c) ARGV_CONFIGURATION=$OPTARG ;;
    m) ARGV_MODULE=$OPTARG ;;
    n) ARGV_NAMESPACE=$OPTARG ;;
    o) ARGV_BASE_DIRECTORY=$OPTARG ;;
    d) DRY_RUN=true ;;
    h) ARGV_HELP=true ;;
    v) ARGV_VERSION=true ;;
    *) usage ;;
  esac
done

if [ -n "$ARGV_HELP" ]
then
  usage
fi

if [ -n "$ARGV_VERSION" ]
then
  echo "$VERSION"
  exit 0
fi

if [ -z "$ARGV_ACTION" ]
then
  ARGV_ACTION="$DOTF_COMMAND_DIRECTION_APPLY"
fi

if [ -z "$ARGV_BASE_DIRECTORY" ]
then
  ARGV_BASE_DIRECTORY="$HOME"
fi

if [ -n "$ARGV_CONFIGURATION" ]
then
  ARGV_CONFIGURATION="$(dotf__utils_get_absolute_path "$ARGV_CONFIGURATION")"
fi

if [ -z "$ARGV_NAMESPACE" ]
then
  ARGV_NAMESPACE="$PWD"
fi

if [ -z "$ARGV_MODULE" ]
then
  dotf__utils_fail "You need to pass a module directory ($0 -m path/to/module)"
fi

# If the module path is relative, then
# resolve it from the namespace.
# See https://stackoverflow.com/a/38948236/1641422
if [ "$ARGV_MODULE" = "${ARGV_MODULE#/}" ]
then
  ARGV_MODULE="$ARGV_NAMESPACE/$ARGV_MODULE"
fi

ARGV_MODULE="$(dotf__utils_get_absolute_path "$ARGV_MODULE")"

if ! dotf_module_is_valid "$ARGV_MODULE"
then
  dotf__utils_fail "Invalid module: $ARGV_MODULE"
fi

dotf_manifest_execute \
  "$ARGV_MODULE" \
  "$ARGV_ACTION" \
  "$ARGV_BASE_DIRECTORY" \
  "$ARGV_CONFIGURATION"
