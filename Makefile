GPP ?= gpp

include build/os.mk

.DEFAULT_GOAL = all
PLATFORMS = macos-arm64 macos-x86_64 linux-aarch64 linux-x86_64
PLATFORM = $(PLATFORM_OS)-$(PLATFORM_ARCH)
DESTINATION ?= $(HOME)

define SYMLINK
ln -f -s $(realpath $<) $@
endef

# This is a common rule that we not want to
# override multiple times
$(DESTINATION)/bin:
	mkdir $@

include modules/ack/targets.mk
include modules/bin/targets.mk
include modules/curl/targets.mk
include modules/debugger/targets.mk
include modules/email/targets.mk
include modules/gem/targets.mk
include modules/ghc/targets.mk
include modules/git/targets.mk
include modules/gnupg/targets.mk
include modules/irc/targets.mk
include modules/npm/targets.mk
include modules/performance/targets.mk
include modules/sed/targets.mk
include modules/ssh/targets.mk
include modules/stdsh/targets.mk
include modules/tmux/targets.mk
include modules/vim/targets.mk
include modules/w3m/targets.mk
include modules/zsh/targets.mk

.PHONY: all bootstrap template help $(MODULES)
all: bootstrap template $(MODULES)

bootstrap: bootstrap.sh
	./$< $@

# Instantiate the template meta target for all platforms and modules
define TEMPLATE_META_RULE
modules/$1/%.$2: modules/$1/%.tpl
	$(GPP) -o $$@ \
		-DOS=$$(word 1,$$(subst -, ,$$(subst .,,$$(suffix $$@)))) \
		-DARCH=$$(word 2,$$(subst -, ,$$(subst .,,$$(suffix $$@)))) \
		-U "" "" "(" "," ")" "(" ")" "\#" "\\" \
		-M "%%" "\n" " " " " "\n" "(" ")" \
		$$<
endef
$(foreach module,$(MODULES),$(foreach platform,$(PLATFORMS),$(eval $(call TEMPLATE_META_RULE,$(module),$(platform)))))

# See https://stackoverflow.com/a/18258352/1641422
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
template: $(foreach template,$(call rwildcard,modules,*.tpl),$(foreach platform,$(PLATFORMS),$(basename $(template)).$(platform)))

help:
	@echo " ______   _______  _______  _______  ___   ___      _______  _______"
	@echo "|      | |       ||       ||       ||   | |   |    |       ||       |"
	@echo "|  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|"
	@echo "| | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ "
	@echo "| |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |"
	@echo "|       ||       |  |   |  |   |    |   | |       ||   |___  _____| |"
	@echo "|______| |_______|  |___|  |___|    |___| |_______||_______||_______|"
	@echo ""
	@echo "Platform: $(PLATFORM)"
	@echo ""
	@echo "Supported modules:"
	@echo ""
	@echo "  $(MODULES)"
	@echo ""
	@echo "Supported platforms:"
	@echo ""
	@echo "  $(PLATFORMS)"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  make all"
	@echo "  make bootstrap"
	@echo "  make template"
	@echo "  make <module>"
