$(DESTINATION)/bin/battery: modules/tmux/battery; $(SYMLINK)
$(DESTINATION)/.tmux.conf: modules/tmux/tmux.conf.$(PLATFORM); $(SYMLINK)
tmux: $(DESTINATION)/bin/battery $(DESTINATION)/.tmux.conf
MODULES += tmux
