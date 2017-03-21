include base.mk

install:
	# Utility scripts
	$(call link-user-file,check-duplicated.pl,bin/check-duplicated.pl)
	$(call link-user-file,check-passive-voice.sh,bin/check-passive-voice.sh)
	$(call link-user-file,check-weasels.sh,bin/check-weasels.sh)
	# Main script
	$(call link-user-file,proof.sh,bin/proof.sh)

uninstall:
	$(call unlink-user-file,bin/check-duplicated.pl)
	$(call unlink-user-file,bin/check-passive-voice.sh)
	$(call unlink-user-file,bin/check-weasels.sh)
	$(call unlink-user-file,bin/proof.sh)
