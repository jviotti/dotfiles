$(DESTINATION)/.zshrc: modules/zsh/zshrc; $(SYMLINK)
zsh: $(DESTINATION)/.zshrc
MODULES += zsh
