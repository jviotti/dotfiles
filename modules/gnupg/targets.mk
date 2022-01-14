$(DESTINATION)/bin/%: modules/gnupg/% | $(DESTINATION)/bin
	$(SYMLINK)

$(DESTINATION)/.gnupg:
	mkdir $@
$(DESTINATION)/.gnupg/gpg-agent.conf: modules/gnupg/gpg-agent.conf | $(DESTINATION)/.gnupg
	$(SYMLINK)
$(DESTINATION)/.gnupg/scdaemon.conf: modules/gnupg/scdaemon.conf | $(DESTINATION)/.gnupg
	$(SYMLINK)

# We need specific permissions on this file
$(DESTINATION)/.gnupg/gpg.conf: modules/gnupg/gpg.conf | $(DESTINATION)/.gnupg
	$(SYMLINK)
	chmod 700 $@

gnupg: \
	$(DESTINATION)/bin/decrypt.sh \
	$(DESTINATION)/bin/encrypt.sh \
	$(DESTINATION)/bin/recipients.sh \
	$(DESTINATION)/bin/gnupg-keypair-export.sh \
	$(DESTINATION)/.gnupg/gpg-agent.conf \
	$(DESTINATION)/.gnupg/scdaemon.conf \
	$(DESTINATION)/.gnupg/gpg.conf
MODULES += gnupg
