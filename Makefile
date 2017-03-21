include utils/base.mk

# Settings
export DOTFILES_LOCATION_USER=$(HOME)
export DOTFILES_LOCATION_SYSTEM=/
export DOTFILES_OS=$(HOST_PLATFORM)
export DOTFILES_MODULES=$(shell ls modules)

help:
	@echo " ______   _______  _______  _______  ___   ___      _______  _______"
	@echo "|      | |       ||       ||       ||   | |   |    |       ||       |"
	@echo "|  _    ||   _   ||_     _||    ___||   | |   |    |    ___||  _____|"
	@echo "| | |   ||  | |  |  |   |  |   |___ |   | |   |    |   |___ | |_____ "
	@echo "| |_|   ||  |_|  |  |   |  |    ___||   | |   |___ |    ___||_____  |"
	@echo "|       ||       |  |   |  |   |    |   | |       ||   |___  _____| |"
	@echo "|______| |_______|  |___|  |___|    |___| |_______||_______||_______|"
	@echo ""
	@echo "Settings:"
	@echo ""
	@echo "  LOCATION_USER:   $(DOTFILES_LOCATION_USER)"
	@echo "  LOCATION_SYSTEM: $(DOTFILES_LOCATION_SYSTEM)"
	@echo "  OS:              $(DOTFILES_OS)"
	@echo "  MODULES:         $(DOTFILES_MODULES)"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  make install-all"
	@echo "  make uninstall-all"
	@echo "  make install-<module>"
	@echo "  make uninstall-<module>"
	@echo "  make build-<module>"
	@echo "  make system"

.PHONY: \
	install-all \
	uninstall-all \
	install-% \
	uninstall-% \
	build-% \
	system

install-all:
	@for module in $(DOTFILES_MODULES); do \
		echo "-------------------------"; \
		echo "Installing $$module"; \
		echo "-------------------------"; \
		make install-$$module; \
	done

uninstall-all:
	@for module in $(DOTFILES_MODULES); do \
		echo "-------------------------"; \
		echo "Uninstalling $$module"; \
		echo "-------------------------"; \
		make uninstall-$$module; \
	done

install-%:
	$(call module-install,$(subst install-,,$@))

uninstall-%:
	$(call module-uninstall,$(subst uninstall-,,$@))

build-%:
	$(call module-build,$(subst build-,,$@))

system:
	$(call make-run,system,install)
