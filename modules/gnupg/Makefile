include base.mk

install:
	$(call link-user-file,gpg.conf,.gnupg/gpg.conf)
	$(call link-user-file,gpg-agent.conf,.gnupg/gpg-agent.conf)
	$(call link-user-file,decrypt.sh,bin/decrypt.sh)
	$(call link-user-file,encrypt.sh,bin/encrypt.sh)
	$(call link-user-file,gnupg-keypair-export.sh,bin/gnupg-keypair-export.sh)

uninstall:
	$(call unlink-user-file,.gnupg/gpg.conf)
	$(call unlink-user-file,.gnupg/gpg-agent.conf)
	$(call unlink-user-file,bin/decrypt.sh)
	$(call unlink-user-file,bin/encrypt.sh)
	$(call unlink-user-file,bin/gnupg-keypair-export.sh)
