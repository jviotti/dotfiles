$(DESTINATION)/.ackrc: modules/ack/ackrc; $(SYMLINK)
ack: $(DESTINATION)/.ackrc
TARGETS += ack
