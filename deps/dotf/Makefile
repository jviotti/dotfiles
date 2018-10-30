PREFIX ?= /usr/local

dotf.1: dotf.1.ronn.md
	ronn --roff $<

index.html: dotf.1.ronn.md
	ronn --html --pipe $< > $@

.PHONY: lint doc install uninstall

lint:
	shellcheck *.sh

doc: dotf.1 index.html

install:
	cp dotf.sh $(PREFIX)/bin/dotf
	mkdir -p $(PREFIX)/share/man/man1
	cp dotf.1 $(PREFIX)/share/man/man1/dotf.1

uninstall:
	rm $(PREFIX)/bin/dotf
	rm $(PREFIX)/share/man/man1/dotf.1

.DEFAULT_GOAL = install
