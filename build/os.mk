PLATFORM_ARCH = $(shell uname -m)
export PLATFORM_ARCH

ifndef PLATFORM_OS
ifeq ($(shell uname),Darwin)
PLATFORM_OS = macos
endif
endif

ifndef PLATFORM_OS
ifeq ($(shell uname),Linux)
PLATFORM_OS = linux
endif
endif

ifndef PLATFORM_OS
ifeq ($(shell uname -o),Msys)
PLATFORM_OS = windows
endif
endif

ifndef PLATFORM_OS
ifeq ($(shell uname -o),Cygwin)
PLATFORM_OS = windows
endif
endif

ifndef PLATFORM_OS
$(error Could not detect the host operating system)
endif
