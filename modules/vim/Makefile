include base.mk

install:
	$(call unlink-user-file,.vim)
	$(call git-clone,https://github.com/jviotti/dotvim,$(DOTFILES_LOCATION_USER)/.vim)
	$(call link-file,$(DOTFILES_LOCATION_USER)/.vim/vimrc,$(DOTFILES_LOCATION_USER)/.vimrc)
	$(call link-file,$(DOTFILES_LOCATION_USER)/.vim/gvimrc,$(DOTFILES_LOCATION_USER)/.gvimrc)
	@echo "Run: vim +PlugInstall to install plugins"

uninstall:
	$(call unlink-user-file,.vim)
	$(call unlink-user-file,.vimrc)
	$(call unlink-user-file,.gvimrc)
