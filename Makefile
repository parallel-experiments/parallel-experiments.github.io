# Makefile

.PHONY: default

default:
	markdown-folder-to-html posts; mv _posts docs
