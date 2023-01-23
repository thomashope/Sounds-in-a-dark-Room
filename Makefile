.PHONY: debug

# launch a debug build
debug:
	love . --debug --skip-intro

# launch a release build
release:
	love .