include vendor/vendorpull/targets.mk
include vendor/bootstrap/targets.mk

.DEFAULT_GOAL = all
DESTINATION ?= $(HOME)

define SYMLINK
ln -s $(realpath $<) $@
endef

TARGETS =
include modules/ack/targets.mk
include modules/bin/targets.mk
include modules/curl/targets.mk

.PHONY: all help $(TARGETS)
all: $(TARGETS)

help:
	@echo $(TARGETS)
