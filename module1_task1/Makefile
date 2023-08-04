build:
	@hugo

post:
	@test -n "$(POST_NAME)" || { echo "ERROR: Variable 'POST_NAME' unset."; exit 1; }
	@cd $(CURDIR) && hugo new posts/$(POST_NAME).md

clean:
	@rm -rf $(CURDIR)/public

.PHONY: build post clean
