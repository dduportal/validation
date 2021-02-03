# Enabled by default with Docker 20.10+
export DOCKER_BUILDKIT=1
app_name = awesome
GIT_TAG = $(shell git describe --exact-match --tags HEAD 2>/dev/null || git rev-parse --abbrev-ref HEAD)
export GIT_TAG
app_image_name = $(shell GIT_TAG=$(GIT_TAG) docker-compose config | grep image | cut -d: -f2,3 | xargs)

lint: ## Execute Static Analysis
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Lint OK"

build: ## Build the application
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Build OK"

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: build-docker-app ## Execute the application in background
	@docker-compose up --detach --build awesome-web

stop: ## Stop the background application
	@docker rm --volumes --force $(app_name) || true

test: unit-tests integration-tests ## Execute all tests

clean: stop ## Cleanup any file or background process
	rm -rf $(binary_name) *.out ./dist/ ./W3C-Validator/ awesome-website.zip *.zip *.tar

docker-tests: build-docker-app ## Execute the test harness to validate that the Docker Images are correct
	container-structure-test test --config=$(CURDIR)/cst.yml --image=$(app_image_name)

unit-tests: ## Execute unit tests with code coverage reporting
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Unit Tests OK"

integration-tests: ## Execute integration tests with code coverage reporting
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Integration Tests OK"

post: ## Create a new post in content/posts/<POST_NAME>.md with title <POST_TITLE>
	@test -n "$(POST_NAME)" || { echo "Please provide a post filename by setting the variable POST_NAME"; exit 1; }
	@test -n "$(POST_TITLE)" || { echo "Please provide a post title by setting the variable POST_TITLE"; exit 1; }
	@docker build --tag=$(app_name):base --target=base --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@docker run --rm --volume $(CURDIR)/..:$(CURDIR)/.. --workdir $(CURDIR) --env POST_NAME --env POST_TITLE $(app_name):base \
		hugo new content/posts/$(POST_NAME).md
	@cat content/posts/$(POST_NAME).md | sed 's/^title:.*/title: $(POST_TITLE)/' | tee content/posts/$(POST_NAME).md

check: ## execute a static analysis on `content/posts/*.md` files to check for dead link and bad writing practises
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Check OK"

validate: ## execute a W3C compliance checking on the generated static website in `./dist`
	@docker build --tag=$(app_name):$@ --target=$@ --file=$(CURDIR)/Dockerfile $(CURDIR)/
	@echo "Validation OK"

build-docker-app: ## Build the final Docker Image
	@docker-compose build awesome-web

package: build-docker-app ## Generate a package of the application with both API and website content and push it to the DockerHub
	@docker-compose push awesome-web
	@docker save $(app_image_name) --output=docker-image.tar && zip awesome-website.zip docker-image.tar && rm -f docker-image.tar

.PHONY: help clean build run stop test lint unit-tests integration-tests post check validate package docker-tests build-docker-app
