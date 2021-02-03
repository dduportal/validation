# No need to use C-Go and avoid requirement to GCC
export CGO_ENABLED=0
export GO11MODULES=on

build:
	hugo

post:
	@test -n "$(POST_NAME)" || { echo "Please provide a post filename by setting the variable POST_NAME"; exit 1; }
	@test -n "$(POST_TITLE)" || { echo "Please provide a post title by setting the variable POST_TITLE"; exit 1; }
	hugo new content/posts/$(POST_NAME).md
	cat content/posts/$(POST_NAME).md | sed 's/^title:.*/title: $(POST_TITLE)/' | tee content/posts/$(POST_NAME).md

clean:
	rm -rf ./dist/

.PHONY: build clean post
