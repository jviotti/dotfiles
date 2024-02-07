$(DESTINATION)/bin/%: modules/sed/% | $(DESTINATION)/bin
	$(SYMLINK)
sed: $(DESTINATION)/bin/gres $(DESTINATION)/bin/replace \
	$(DESTINATION)/bin/runsed.sh $(DESTINATION)/bin/testsed.sh
MODULES += sed
