$(DESTINATION)/bin/cpu_profile: modules/performance/cpu_profile.sh | $(DESTINATION)/bin
	$(SYMLINK)

performance: $(DESTINATION)/bin/cpu_profile
MODULES += performance
