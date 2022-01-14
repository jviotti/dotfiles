include vendor/vendorpull/targets.mk
include vendor/bootstrap/targets.mk

.PHONY: all
.DEFAULT_GOAL = all
DESTINATION ?= $(HOME)

include modules/ack/targets.mk

all: ack
