include base.mk

install:
	$(call link-user-file,config,.newsboat/config)
	$(call link-user-file,urls,.newsboat/urls)

uninstall:
	$(call unlink-user-file,.newsboat/config)
	$(call unlink-user-file,.newsboat/urls)
