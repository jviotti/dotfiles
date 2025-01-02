$(DESTINATION)/bin/%: modules/bin/% | $(DESTINATION)/bin
	$(SYMLINK)
bin: \
	$(DESTINATION)/bin/xzcompress.sh \
	$(DESTINATION)/bin/repeat.sh \
	$(DESTINATION)/bin/music.sh \
	$(DESTINATION)/bin/until-works.sh \
	$(DESTINATION)/bin/youtube-mp3.sh \
	$(DESTINATION)/bin/windows.sh \
	$(DESTINATION)/bin/flac2aiff.sh
MODULES += bin
