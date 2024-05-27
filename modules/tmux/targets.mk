$(DESTINATION)/.tmux.conf: modules/tmux/tmux.conf.$(PLATFORM); $(SYMLINK)
tmux: $(DESTINATION)/.tmux.conf
MODULES += tmux
