$(DESTINATION)/.ackrc: modules/ack/ackrc; $(SYMLINK)
ack: $(DESTINATION)/.ackrc
MODULES += ack
