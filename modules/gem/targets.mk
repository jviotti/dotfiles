$(DESTINATION)/.gemrc: modules/gem/gemrc; $(SYMLINK)
gem: $(DESTINATION)/.gemrc
MODULES += gem
