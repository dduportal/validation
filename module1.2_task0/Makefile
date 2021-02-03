# No need to use C-Go and avoid requirement to GCC
export CGO_ENABLED=0
export GO11MODULES=on

binary_name = awesome-api
log_filename = awesome.log

build: ## Build the application
	go build -o $(binary_name)

help: ## Show this Makefile's help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## Execute the application in background
	./$(binary_name) > $(log_filename) 2>&1 &

stop: ## Stop the background application
	kill $(shell pgrep $(binary_name)) 2>/dev/null || true

test: ## Execute requests to smoke-test the application
	curl "http://localhost:9999"
	curl "http://localhost:9999/health"

clean: stop ## Cleanup any file or background process
	rm -f $(binary_name) $(log_filename)

.PHONY: help clean build run stop test
