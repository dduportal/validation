# No need to use C-Go and avoid requirement to GCC
export CGO_ENABLED=0
export GO11MODULES=on

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the website
	hugo

post: ## Create a new post in content/posts/<POST_NAME>.md with title <POST_TITLE>
	@test -n "$(POST_NAME)" || { echo "Please provide a post filename by setting the variable POST_NAME"; exit 1; }
	@test -n "$(POST_TITLE)" || { echo "Please provide a post title by setting the variable POST_TITLE"; exit 1; }
	hugo new content/posts/$(POST_NAME).md
	cat content/posts/$(POST_NAME).md | sed 's/^title:.*/title: $(POST_TITLE)/' | tee content/posts/$(POST_NAME).md

clean: ## Cleanup directories from any generated files
	rm -rf ./dist/

.PHONY: build clean post help
