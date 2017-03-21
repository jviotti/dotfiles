include base.mk

install:
	$(call copy-file-in-current-directory,hosts,/etc/hosts)
# Reload host file 
ifeq ($(HOST_PLATFORM),darwin)
	dscacheutil -flushcache
	killall -HUP mDNSResponder
endif
