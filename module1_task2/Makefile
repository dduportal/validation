
.PHONY: build
build: ## Generate website from source into ./public
	git submodule update --init --recursive
	ls -latrh
	hugo

.PHONY: post
post: ## Create a new post (required variable POST_NAME to be set)
	@test -n "$(POST_NAME)" || { echo "ERROR: Variable 'POST_NAME' unset."; exit 1; }
	@cd $(CURDIR) && hugo new posts/$(POST_NAME).md

.PHONY: clean
clean: ## Cleanup generated website
	@rm -rf $(CURDIR)/public

.PHONY: help
help: ## Print the makefile usage
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
