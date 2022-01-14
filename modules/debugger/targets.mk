$(DESTINATION)/.gdbinit: modules/debugger/gdbinit; $(SYMLINK)
$(DESTINATION)/.lldbinit: modules/debugger/lldbinit; $(SYMLINK)
debugger: $(DESTINATION)/.gdbinit
TARGETS += debugger
