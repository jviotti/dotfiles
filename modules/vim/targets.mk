$(DESTINATION)/.vimundo:
	mkdir $@

$(DESTINATION)/.vimrc: modules/vim/vimrc; $(SYMLINK)
$(DESTINATION)/.gvimrc: modules/vim/gvimrc; $(SYMLINK)

$(DESTINATION)/.vim:
	mkdir $@
$(DESTINATION)/.vim/%: modules/vim/% | $(DESTINATION)/.vim
	$(SYMLINK)

vim: \
	$(DESTINATION)/.vimundo \
	$(DESTINATION)/.vimrc \
	$(DESTINATION)/.gvimrc \
	$(DESTINATION)/.vim/colors \
	$(DESTINATION)/.vim/autoload \
	$(DESTINATION)/.vim/spellfile.add
MODULES += vim
