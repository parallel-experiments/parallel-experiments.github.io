# Makefile

.PHONY: default

default:
	markdown-folder-to-html posts; rm -rf docs; mv _posts docs
