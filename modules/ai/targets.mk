$(DESTINATION)/.claude:
	mkdir $@

# See https://docs.claude.com/en/docs/claude-code/memory
$(DESTINATION)/.claude/CLAUDE.md: modules/ai/CLAUDE.md | $(DESTINATION)/.claude
	$(SYMLINK)

$(DESTINATION)/.claude/sandbox-exec.profile: modules/ai/sandbox-exec.profile | $(DESTINATION)/.claude
	$(SYMLINK)
$(DESTINATION)/bin/safeclaude: modules/ai/safeclaude.sh | $(DESTINATION)/bin
	$(SYMLINK)

ai: \
	$(DESTINATION)/.claude/CLAUDE.md \
	$(DESTINATION)/.claude/sandbox-exec.profile \
	$(DESTINATION)/bin/safeclaude
MODULES += ai
