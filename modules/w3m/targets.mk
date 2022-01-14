$(DESTINATION)/.w3m:
	mkdir $@
$(DESTINATION)/.w3m/config: modules/w3m/config | $(DESTINATION)/.w3m
	$(SYMLINK)
w3m: $(DESTINATION)/.w3m/config
MODULES += w3m
