$(DESTINATION)/.curlrc: modules/curl/curlrc; $(SYMLINK)

.PHONY: curl
curl: $(DESTINATION)/.curlrc
