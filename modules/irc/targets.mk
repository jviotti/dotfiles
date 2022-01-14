$(DESTINATION)/.irssi:
	mkdir $@
$(DESTINATION)/.irssi/config: modules/irc/config | $(DESTINATION)/.irssi
	$(SYMLINK)
$(DESTINATION)/.irssi/default.theme: modules/irc/default.theme | $(DESTINATION)/.irssi
	$(SYMLINK)
irc: $(DESTINATION)/.irssi/config $(DESTINATION)/.irssi/default.theme
MODULES += irc
