build:
	git submodule update --init --recursive
	ls -latrh
	hugo

post:
	@test -n "$(POST_NAME)" || { echo "ERROR: Variable 'POST_NAME' unset."; exit 1; }
	@cd $(CURDIR) && hugo new posts/$(POST_NAME).md

clean:
	@rm -rf $(CURDIR)/public

help:
	echo "Help"

.PHONY: build post clean help
