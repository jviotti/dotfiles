include base.mk

install:
	$(call link-user-file,vimrc,.vimrc)
	$(call link-user-file,gvimrc,.gvimrc)
	$(call link-user-file,colors,.vim/colors)
	$(call link-user-file,autoload,.vim/autoload)

uninstall:
	$(call unlink-user-file,.vimrc)
	$(call unlink-user-file,.gvimrc)
	$(call unlink-user-file,.vim/colors)
	$(call unlink-user-file,.vim/autoload)
