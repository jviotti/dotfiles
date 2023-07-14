$(DESTINATION)/.gdbinit: modules/debugger/gdbinit; $(SYMLINK)
$(DESTINATION)/.lldbinit: modules/debugger/lldbinit; $(SYMLINK)
$(DESTINATION)/.lldb:
	mkdir $@
$(DESTINATION)/.lldb/jviotti.py: modules/debugger/jviotti.py | $(DESTINATION)/.lldb
	$(SYMLINK)
debugger: $(DESTINATION)/.gdbinit $(DESTINATION)/.lldbinit \
	$(DESTINATION)/.lldb/jviotti.py
MODULES += debugger
