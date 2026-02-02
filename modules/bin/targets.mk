$(DESTINATION)/bin/%: modules/bin/% | $(DESTINATION)/bin
	$(SYMLINK)
bin: \
	$(DESTINATION)/bin/sourcemeta-upgrade.sh \
	$(DESTINATION)/bin/xzcompress.sh \
	$(DESTINATION)/bin/repeat.sh \
	$(DESTINATION)/bin/music.sh \
	$(DESTINATION)/bin/cloud.sh \
	$(DESTINATION)/bin/until-works.sh \
	$(DESTINATION)/bin/youtube-mp3.sh \
	$(DESTINATION)/bin/windows.sh \
	$(DESTINATION)/bin/flac2aiff.sh \
	$(DESTINATION)/bin/aiffcover.sh \
	$(DESTINATION)/bin/linux.sh
MODULES += bin
