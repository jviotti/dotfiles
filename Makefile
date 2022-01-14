include vendor/vendorpull/targets.mk
include vendor/bootstrap/targets.mk

.PHONY: all
.DEFAULT_GOAL = all
DESTINATION ?= $(HOME)

SYMLINK ?= ln -s

include modules/ack/targets.mk

all: ack
