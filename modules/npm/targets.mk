$(DESTINATION)/.npmrc: modules/npm/npmrc; $(SYMLINK)
$(DESTINATION)/bin/npm_publish.sh: modules/npm/npm_publish.sh | $(DESTINATION)/bin
	$(SYMLINK)
npm: $(DESTINATION)/.npmrc $(DESTINATION)/bin/npm_publish.sh
MODULES += npm
