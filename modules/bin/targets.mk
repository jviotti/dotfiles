$(DESTINATION)/bin/%: modules/bin/% | $(DESTINATION)/bin
	$(SYMLINK)
bin: \
	$(DESTINATION)/bin/xzcompress.sh \
	$(DESTINATION)/bin/repeat.sh \
	$(DESTINATION)/bin/youtube-mp3.sh \
	$(DESTINATION)/bin/windows.sh
MODULES += bin
