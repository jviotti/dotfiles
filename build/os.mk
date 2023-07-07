ifndef PLATFORM_ARCH
PLATFORM_ARCH = $(shell uname -m)
endif

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
$(error Could not detect the host operating system)
endif
