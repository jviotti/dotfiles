$(DESTINATION)/.curlrc: modules/curl/curlrc; $(SYMLINK)
curl: $(DESTINATION)/.curlrc
TARGETS += curl
