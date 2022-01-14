$(DESTINATION)/.ghc:
	mkdir $@

$(DESTINATION)/.ghc/ghci.conf: modules/ghc/ghci.conf | $(DESTINATION)/.ghc
	$(SYMLINK)

ghc: $(DESTINATION)/.ghc/ghci.conf
MODULES += ghc
