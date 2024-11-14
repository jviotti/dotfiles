$(DESTINATION)/.mutt:
	mkdir $@
$(DESTINATION)/.mutt/aliases:
	touch $@
$(DESTINATION)/.mutt/cache: | $(DESTINATION)/.mutt
	mkdir $@
$(DESTINATION)/Mail:
	mkdir $@
$(DESTINATION)/Mail/Personal: | $(DESTINATION)/Mail
	mkdir $@

$(DESTINATION)/.mbsyncrc: modules/email/mbsyncrc.$(PLATFORM); $(SYMLINK)
$(DESTINATION)/.msmtprc: modules/email/msmtprc.$(PLATFORM); $(SYMLINK)
$(DESTINATION)/.mailcap: modules/email/mailcap; $(SYMLINK)
$(DESTINATION)/.offlineimaprc: modules/email/offlineimaprc; $(SYMLINK)
$(DESTINATION)/.offlineimap.py: modules/email/offlineimap.py; $(SYMLINK)

$(DESTINATION)/.mutt/muttrc: modules/email/muttrc | $(DESTINATION)/.mutt
	$(SYMLINK)
$(DESTINATION)/.mutt/signature: modules/email/signature | $(DESTINATION)/.mutt
	$(SYMLINK)
$(DESTINATION)/bin/email: modules/email/email.sh | $(DESTINATION)/bin
	$(SYMLINK)
$(DESTINATION)/bin/msmtp-wrapper: modules/email/msmtp-wrapper.sh | $(DESTINATION)/bin
	$(SYMLINK)

email: \
	$(DESTINATION)/.mutt/cache \
	$(DESTINATION)/.mbsyncrc \
	$(DESTINATION)/.msmtprc \
	$(DESTINATION)/.offlineimaprc \
	$(DESTINATION)/.offlineimap.py \
	$(DESTINATION)/.mutt/muttrc \
	$(DESTINATION)/.mutt/signature \
	$(DESTINATION)/Mail \
	$(DESTINATION)/Mail/Personal \
	$(DESTINATION)/.mutt/aliases \
	$(DESTINATION)/.mailcap \
	$(DESTINATION)/bin/email \
	$(DESTINATION)/bin/msmtp-wrapper
MODULES += email
