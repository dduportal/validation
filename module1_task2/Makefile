build: ## Generate website from source into ./public
	git submodule update --init --recursive
	ls -latrh
	hugo

post: ## Create a new post (required variable POST_NAME to be set)
	@test -n "$(POST_NAME)" || { echo "ERROR: Variable 'POST_NAME' unset."; exit 1; }
	@cd $(CURDIR) && hugo new posts/$(POST_NAME).md

clean: ## Cleanup generated website
	@rm -rf $(CURDIR)/public

.PHONY: cook
cook:     ## Prepare a meal in the current kitchen
	cook ./kitchen

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build post clean help
