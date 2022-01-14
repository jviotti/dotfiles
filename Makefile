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
	@echo " ______   _______  _______  _______  ___   ___      _______  _______"
	@echo "|      | |       ||       ||       ||   | |   |    |       ||       |"
	@echo "|  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|"
	@echo "| | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ "
	@echo "| |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |"
	@echo "|       ||       |  |   |  |   |    |   | |       ||   |___  _____| |"
	@echo "|______| |_______|  |___|  |___|    |___| |_______||_______||_______|"
	@echo ""
	@echo "MODULES: $(TARGETS)"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  make all"
	@echo "  make <module>"
