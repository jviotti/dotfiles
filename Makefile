include vendor/vendorpull/targets.mk
include vendor/bootstrap/targets.mk

.PHONY: all
.DEFAULT_GOAL = all
DESTINATION ?= $(HOME)

define SYMLINK
ln -s $(realpath $<) $@
endef

include modules/ack/targets.mk
include modules/bin/targets.mk
include modules/curl/targets.mk

all: ack bin curl
