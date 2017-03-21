include base.mk

install:
	$(call link-user-file,npmrc,.npmrc)
	$(call link-user-file,npm_run.sh,bin/npm_run.sh)
	$(call link-user-file,npm_publish.sh,bin/npm_publish.sh)
	$(call link-user-file,npm_update_dep.sh,bin/npm_update_dep.sh)

uninstall:
	$(call unlink-user-file,.npmrc)
	$(call unlink-user-file,bin/npm_run.sh)
	$(call unlink-user-file,bin/npm_publish.sh)
	$(call unlink-user-file,bin/npm_update_dep.sh)
