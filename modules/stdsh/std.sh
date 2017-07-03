#!/bin/sh

set -e
set -u

# Set bash in POSIX compatibility mode
set -o posix

###
# @summary The directory name of the stdsh library
# @constant
# @private
###
_STDSH_HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export _STDSH_HERE

###
# @summary Abort the script execution
# @function
# @public
#
# @param {String} message
#
# @example
# stdsh_fail "Something went wrong!"
###
stdsh_fail() {
  echo "$1" 1>&2
  exit 1
}

###
# @summary Add a path to $PATH, if it exists
# @function
# @public
#
# @param {String} path
#
# @example
# stdsh_path_add "/usr/local/bin"
###
stdsh_path_add() {
  if [ ! -d "$1" ]; then
    stdsh_fail "$1 is not a directory"
  fi
  PATH=$PATH:$1
}

###
# @summary Check if a command exists
# @function
# @public
#
# @param {String} command
#
# @example
# if stdsh_has_command "foo"; then
#   echo "This command exists"
# fi
###
stdsh_has_command() {
  command -v "$1" 2>/dev/null 1>&2
}

###
# @summary Check if a dependency exists, fail otherwise
# @function
# @public
#
# @param {String} dependency
#
# @example
# stdsh_dependency_check "uconv"
###
stdsh_dependency_check() {
  if ! stdsh_has_command "$1"; then
    stdsh_fail "Dependency required: $1"
  fi
}

###
# @summary The ternary conditional expression
# @function
# @public
#
# @param {String|Number} expression
# @param {String} result, if expression is true
# @param {String} result, if expression is false
#
# @example
# VARIABLE="$STDSH_CONSTANT_TRUE"
# RESULT="$(stdsh_if_expression "$VARIABLE" foo bar)"
# echo "$RESULT"
# > foo
##
stdsh_if_expression() {
  if stdsh_is_true "$1"; then 
    echo "$2"
  else 
    echo "$3"
  fi
}

###
# @summary Check if a variable is true
# @function
# @public
#
# @param {String|Number} variable
#
# @example
# VARIABLE=1
# if stdsh_is_true "$VARIABLE"; then
#   echo "The variable is true"
# fi
###
stdsh_is_true() {
  [ "$1" = "1" ] || [ "$1" = "true" ]
}

###
# @summary The true value
# @constant
# @public
#
# @example
# VARIABLE="$STDSH_CONSTANT_TRUE"
###
export STDSH_CONSTANT_TRUE=1

###
# @summary The false value
# @constant
# @public
#
# @example
# VARIABLE="$STDSH_CONSTANT_FALSE"
###
export STDSH_CONSTANT_FALSE=0

###
# @summary Check if a variable is defined
# @function
# @public
#
# @param {String|Number} variable
#
# @example
# VARIABLE=1
# if stdsh_is_defined "$VARIABLE"; then
#   echo "The variable is defined"
# fi
###
stdsh_is_defined() {
  [ -n "$1" ]
}

###
# @summary Check if a variable is undefined
# @function
# @public
#
# @param {String|Number} variable
#
# @example
# VARIABLE=""
# if stdsh_is_undefined "$VARIABLE"; then
#   echo "The variable is undefined"
# fi
###
stdsh_is_undefined() {
  [ -z "$1" ]
}

###
# @summary Get the first line of text
# @function
# @public
#
# @example
# cat file | stdsh_filter_get_first_line
###
stdsh_filter_get_first_line() {
  head -n 1
}
