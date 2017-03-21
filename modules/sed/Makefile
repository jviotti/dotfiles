include base.mk

install:
	$(call link-user-file,testsed.sh,bin/testsed.sh)
	$(call link-user-file,runsed.sh,bin/runsed.sh)
	$(call link-user-file,gres,bin/gres)

uninstall:
	$(call unlink-user-file,bin/testsed.sh)
	$(call unlink-user-file,bin/runsed.sh)
	$(call unlink-user-file,bin/gres)
