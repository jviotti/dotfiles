$(DESTINATION)/.ssh:
	mkdir $@
$(DESTINATION)/.ssh/config: modules/ssh/config.$(PLATFORM) | $(DESTINATION)/.ssh
	$(SYMLINK)
ssh: $(DESTINATION)/.ssh/config
MODULES += ssh
