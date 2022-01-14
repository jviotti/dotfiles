$(DESTINATION)/.gitconfig: modules/git/gitconfig.$(PLATFORM); $(SYMLINK)
$(DESTINATION)/bin/git-ci: modules/git/git-ci | $(DESTINATION)/bin
	$(SYMLINK)
$(DESTINATION)/.gitdefaultcommit: modules/git/gitdefaultcommit; $(SYMLINK)
git: $(DESTINATION)/.gitconfig $(DESTINATION)/bin/git-ci $(DESTINATION)/.gitdefaultcommit
MODULES += git
