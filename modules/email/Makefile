include base.mk

install:
	$(call link-user-file,mailcap,.mailcap)
	$(call link-user-file,offlineimaprc,.offlineimaprc)
	$(call link-user-file,offlineimap.py,.offlineimap.py)
	$(call link-user-file,muttrc,.mutt/muttrc)
	$(call link-user-file,signature,.mutt/signature)
	mkdir -p $(HOME)/.mutt/cache
	mkdir -p $(HOME)/Mail

uninstall:
	$(call unlink-user-file,.mailcap)
	$(call unlink-user-file,.offlineimaprc)
	$(call unlink-user-file,.offlineimap.py)
	$(call unlink-user-file,.mutt/muttrc)
	$(call unlink-user-file,.mutt/signature)
