#!/bin/sh

set -o errexit
set -o nounset

PROMPT="$(cat <<EOF
- Try to copy the existing coding conventions from other files as much as you can for consistency purposes
- Prioritise performance whenever possible. Avoid unnecessary copies or memory allocations if possible
- Never use acronyms or short variable names. Prefer descriptive names. Like 'index' instead of 'i' and 'attributes' instead of 'attrs'
- Always build and test your changes to confirm they work properly. If the project has a 'Makefile', then run 'make'
- On C++ projects, use 'camel_case' for variables
- On C++ projects, make sure that the system includes for every file are correct and have a right comment with the symbols it is needed for 
- On C++ projects, use {  } initialisers as much as possible compared to ( ) initialisers or the = sign
- On C++ projects, assume C++20
- On C++ projects, always use trailing return types, including for 'void'
- For CMake projects that define a top-level Makefile, prefer running 'make' for compiling and testing the project instead of manually running 'cmake' or 'ctest'
EOF
)"

exec /opt/homebrew/bin/claude --append-system-prompt "$PROMPT"
