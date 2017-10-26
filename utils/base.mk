# http://stackoverflow.com/a/12099167
ifeq ($(shell uname -s),Linux)
	HOST_PLATFORM = linux
endif
ifeq ($(shell uname -s),Darwin)
	HOST_PLATFORM = darwin
endif
ifeq ($(shell uname -s),OpenBSD)
	HOST_PLATFORM = openbsd
endif

ifndef HOST_PLATFORM
$(error We couldn't detect your host platform)
endif

make-run = make -C "$(1)" --include-dir="$(CURDIR)/utils" "$(2)"
module-run = $(call make-run,modules/$(1),$(2))
module-install = $(call module-run,$(1),install)
module-uninstall = $(call module-run,$(1),uninstall)
module-build = $(call module-run,$(1),build)
git-clone = git clone "$(1)" "$(2)"
copy-file = mkdir -p "$(shell dirname "$(2)")" && cp "$(1)" "$(2)"
copy-file-in-current-directory = $(call copy-file,$(CURDIR)/$(1),$(2))
link-file = mkdir -p "$(shell dirname "$(2)")" && ln -f -s "$(1)" "$(2)"
link-file-in-current-directory = $(call link-file,$(CURDIR)/$(1),$(2))
unlink = rm -rf "$(1)"
unlink-user-file = $(call unlink,$(DOTFILES_LOCATION_USER)/$(1))
link-user-file = $(call link-file-in-current-directory,$(1),$(DOTFILES_LOCATION_USER)/$(2))
link-user-file-by-os = $(call link-user-file,$(3)/$(HOST_PLATFORM)/$(1),$(2))
link-system-file = $(call link-file-in-current-directory,$(1),$(DOTFILES_LOCATION_SYSTEM)/$(2))
execute-os-template = mkdir -p $(3)/$(2) && gpp \
	-o $(3)/$(2)/$(1) \
	-DOS=$(2) \
	-DVERSION=$(3) \
	-U "" "" "(" "," ")" "(" ")" "\#" "\\" \
	-M "%%" "\n" " " " " "\n" "(" ")" $(1)
template-file = : \
	&& $(call execute-os-template,$(1),linux,$(2)) \
	&& $(call execute-os-template,$(1),darwin,$(2))
