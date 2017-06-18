include base.mk

install:
	$(call link-user-file,pass-extensions/user.bash,.password-store/.extensions/user.bash)
	$(call link-user-file,pass-extensions/sync.bash,.password-store/.extensions/sync.bash)
	$(call link-user-file,pass-extensions/key.bash,.password-store/.extensions/key.bash)
	$(call link-user-file,generate-password.sh,bin/generate-password.sh)

uninstall:
	$(call unlink-user-file,.password-store/.extensions/user.bash)
	$(call unlink-user-file,.password-store/.extensions/sync.bash)
	$(call unlink-user-file,.password-store/.extensions/key.bash)
	$(call unlink-user-file,bin/generate-password.sh)
