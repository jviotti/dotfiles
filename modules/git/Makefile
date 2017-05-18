include base.mk

build:
	$(call template-file,gitconfig,2.13.0)

install:
	$(call link-user-file-by-os,gitconfig,.gitconfig,$(GIT_VERSION))
	$(call link-user-file,gitdefaultcommit,.gitdefaultcommit)
	$(call link-user-file,gitignore_global,.gitignore_global)

uninstall:
	$(call unlink-user-file,.gitconfig)
	$(call unlink-user-file,.gitdefaultcommit)
	$(call unlink-user-file,.gitignore_global)
