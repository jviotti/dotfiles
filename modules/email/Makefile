include base.mk

install:
	$(call link-user-file,mailcap,.mailcap)
	$(call link-user-file,muttrc,.mutt/muttrc)
	$(call link-user-file,signature,.mutt/signature)
	mkdir -p $(HOME)/.mutt/cache

uninstall:
	$(call unlink-user-file,.mailcap)
	$(call unlink-user-file,.mutt/muttrc)
	$(call unlink-user-file,.mutt/signature)
