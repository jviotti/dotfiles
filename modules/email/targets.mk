$(DESTINATION)/.mutt:
	mkdir $@
$(DESTINATION)/.mutt/cache: | $(DESTINATION)/.mutt
	mkdir $@
$(DESTINATION)/Mail:
	mkdir $@

$(DESTINATION)/.mbsyncrc: modules/email/mbsyncrc.$(PLATFORM); $(SYMLINK)
$(DESTINATION)/.msmtprc: modules/email/msmtprc.$(PLATFORM); $(SYMLINK)
$(DESTINATION)/.mailcap: modules/email/mailcap; $(SYMLINK)

$(DESTINATION)/.mutt/muttrc: modules/email/muttrc.$(PLATFORM) | $(DESTINATION)/.mutt
	$(SYMLINK)
$(DESTINATION)/.mutt/signature: modules/email/signature | $(DESTINATION)/.mutt
	$(SYMLINK)
$(DESTINATION)/bin/email: modules/email/email.sh | $(DESTINATION)/bin
	$(SYMLINK)

email: \
	$(DESTINATION)/.mutt/cache \
	$(DESTINATION)/.mbsyncrc \
	$(DESTINATION)/.msmtprc \
	$(DESTINATION)/.mutt/muttrc \
	$(DESTINATION)/Mail \
	$(DESTINATION)/.mailcap \
	$(DESTINATION)/bin/email
MODULES += email
