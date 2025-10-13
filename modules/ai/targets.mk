$(DESTINATION)/.claude:
	mkdir $@
# See https://docs.claude.com/en/docs/claude-code/memory
$(DESTINATION)/.claude/CLAUDE.md: modules/ai/CLAUDE.md | $(DESTINATION)/.claude
	$(SYMLINK)
ai: \
	$(DESTINATION)/.claude/CLAUDE.md
MODULES += ai
