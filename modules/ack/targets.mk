.PHONY: ack

$(DESTINATION)/.ackrc: modules/ack/ackrc
	ln -s $(realpath $<) $@

ack: $(DESTINATION)/.ackrc
