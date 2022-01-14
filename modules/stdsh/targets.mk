$(DESTINATION)/.std.sh: modules/stdsh/std.sh; $(SYMLINK)
stdsh: $(DESTINATION)/.std.sh
MODULES += stdsh
