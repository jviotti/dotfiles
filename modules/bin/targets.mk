$(DESTINATION)/bin/xzcompress.sh: modules/bin/xzcompress.sh | $(DESTINATION)/bin
	$(SYMLINK)
$(DESTINATION)/bin/repeat.sh: modules/bin/repeat.sh | $(DESTINATION)/bin
	$(SYMLINK)
$(DESTINATION)/bin/youtube-mp3.sh: modules/bin/youtube-mp3.sh | $(DESTINATION)/bin
	$(SYMLINK)

bin: $(DESTINATION)/bin/xzcompress.sh $(DESTINATION)/bin/repeat.sh $(DESTINATION)/bin/youtube-mp3.sh
MODULES += bin
