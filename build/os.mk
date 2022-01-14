ifndef PLATFORM_OS
ifeq ($(OS),Windows_NT)
PLATFORM_OS = windows
ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
PLATFORM_ARCH = x86_64
else
ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
PLATFORM_ARCH = x86_64
endif
endif
endif
endif

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
