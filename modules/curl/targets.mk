$(DESTINATION)/.curlrc: modules/curl/curlrc; $(SYMLINK)
curl: $(DESTINATION)/.curlrc
MODULES += curl
