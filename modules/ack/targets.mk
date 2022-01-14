.PHONY: ack

$(DESTINATION)/.ackrc: modules/ack/ackrc
	$(SYMLINK) $(realpath $<) $@

ack: $(DESTINATION)/.ackrc
