$(DESTINATION)/.ackrc: modules/ack/ackrc; $(SYMLINK)

.PHONY: ack
ack: $(DESTINATION)/.ackrc
