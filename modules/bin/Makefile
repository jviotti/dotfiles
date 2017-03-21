include base.mk

install:
	$(call link-user-file,byte-size,bin/byte-size)
	$(call link-user-file,ntfs-mount.sh,bin/ntfs-mount.sh)
	$(call link-user-file,reformat.sh,bin/reformat.sh)
	$(call link-user-file,server.sh,bin/server.sh)
	$(call link-user-file,sparse-expand.sh,bin/sparse-expand.sh)
	$(call link-user-file,xzcompress.sh,bin/xzcompress.sh)
	$(call link-user-file,mov2gif.sh,bin/mov2gif.sh)
	$(call link-user-file,safe-delete.sh,bin/safe-delete.sh)

uninstall:
	$(call unlink-user-file,bin/byte-size)
	$(call unlink-user-file,bin/ntfs-mount.sh)
	$(call unlink-user-file,bin/reformat.sh)
	$(call unlink-user-file,bin/server.sh)
	$(call unlink-user-file,bin/xzcompress.sh)
	$(call unlink-user-file,bin/mov2gif.sh)
	$(call unlink-user-file,bin/safe-delete.sh)
