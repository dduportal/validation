build: ## Generate website from source into ./public
	git submodule update --init --recursive
	ls -latrh
	hugo

post: ## Create a new post (required variable POST_NAME to be set)
	@test -n "$(POST_NAME)" || { echo "ERROR: Variable 'POST_NAME' unset."; exit 1; }
	@cd $(CURDIR) && hugo new posts/$(POST_NAME).md

clean: ## Cleanup generated website
	@rm -rf $(CURDIR)/public

help: ## Print help
	echo "build clean post help"

.PHONY: build post clean help
