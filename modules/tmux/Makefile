include base.mk

build:
	$(call template-file,tmux.conf)

install:
	$(call link-user-file-by-os,tmux.conf,.tmux.conf)
	$(call link-user-file,battery,bin/battery)

uninstall:
	$(call unlink-user-file,.tmux.conf)
	$(call unlink-user-file,bin/battery)
