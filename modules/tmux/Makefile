include base.mk

build:
	$(call template-file,tmux.conf,1.8)
	$(call template-file,tmux.conf,2.4)

install:
	$(call link-user-file-by-os,tmux.conf,.tmux.conf,$(TMUX_VERSION))
	$(call link-user-file,battery,bin/battery)

uninstall:
	$(call unlink-user-file,.tmux.conf)
	$(call unlink-user-file,bin/battery)
