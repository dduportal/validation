
binary_name = awesome-api
log_filename = awesome.log

# No need to use C-Go and avoid requirement to GCC
export CGO_ENABLED=0
export GO11MODULES=on

build: ## Build the application
	go build -o $(binary_name)
	hugo

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## Execute the application in background
	./$(binary_name) > $(log_filename) 2>&1 &

stop: ## Stop the background application
	kill $(shell pgrep $(binary_name)) 2>/dev/null || true

test: unit-tests integration-tests ## Execute all tests

clean: stop ## Cleanup any file or background process
	rm -rf $(binary_name) $(log_filename) *.out ./dist/ ./W3C-Validator/ awesome-website.zip

lint: ## Execute Static Analysis
	golangci-lint run
	shellcheck setup.sh
	markdownlint README.md DEPLOY.md

unit-tests: ## Execute unit tests with code coverage reporting
	go test -v -short -coverprofile=coverage-units.out

integration-tests: ## Execute integration tests with code coverage reporting
	go test -v -coverprofile=coverage-integrations.out

post: ## Create a new post in content/posts/<POST_NAME>.md with title <POST_TITLE>
	@test -n "$(POST_NAME)" || { echo "Please provide a post filename by setting the variable POST_NAME"; exit 1; }
	@test -n "$(POST_TITLE)" || { echo "Please provide a post title by setting the variable POST_TITLE"; exit 1; }
	hugo new content/posts/$(POST_NAME).md
	cat content/posts/$(POST_NAME).md | sed 's/^title:.*/title: $(POST_TITLE)/' | tee content/posts/$(POST_NAME).md

check: ## execute a static analysis on `content/posts/*.md` files to check for dead link and bad writing practises
	find ./content -type f -name "*.md" -exec markdown-link-check {} \;
	markdownlint ./content/**/*.md

validate: build W3C-Validator/w3c_validator.py ## execute a W3C compliance checking on the generated static website in `./dist`
	# This instruction never fails
	python3 ./W3C-Validator/w3c_validator.py ./dist/index.html || true

W3C-Validator/w3c_validator.py: ## Non PHONY target to ebsure that we always have the python script available
	git clone https://github.com/holbertonschool/W3C-Validator.git

package: dist awesome-api ## Generate a package of the application with both API and website content
	rm -f awesome-website.zip
	zip -r awesome-website.zip ./awesome-api ./dist/ DEPLOY.md
	unzip -t awesome-website.zip

.PHONY: help clean build run stop test lint unit-tests integration-tests post check validate package

## Non phony targets to ensure dependencies
dist:
	@make -C $(CURDIR) build

awesome-api:
	@make -C $(CURDIR) build

awesome-website.zip:
	@make -C $(CURDIR) package
