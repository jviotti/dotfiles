.PHONY: all lint test clean
.DEFAULT_GOAL = all

all: clean lint test

lint: bootstrap
	shellcheck $^ test/**/*.sh

.tmp: 
	mkdir $@

test: bootstrap | .tmp
	OUTPUT=$| exec ./$< $@
	test -f $|/OS-TEST-PASSED || \
		(echo "No bootstrap script was executed" >&2 && exit 1)
	test -f $|/DUMMY || \
		(echo "The dummy script was not executed" >&2 && exit 1)
	test -f $|/ANY || \
		(echo "The any script was not executed" >&2 && exit 1)

clean:
	rm -rf .tmp
