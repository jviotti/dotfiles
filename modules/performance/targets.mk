$(DESTINATION)/bin/cpu_profile: modules/performance/cpu_profile.sh | $(DESTINATION)/bin
	$(SYMLINK)
$(DESTINATION)/bin/full_profile: modules/performance/full_profile.sh | $(DESTINATION)/bin
	$(SYMLINK)

performance: $(DESTINATION)/bin/cpu_profile $(DESTINATION)/bin/full_profile
MODULES += performance
