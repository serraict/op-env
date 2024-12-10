.PHONY: all release version

VERSION := $(shell gitversion /showvariable SemVer)
NEXT_VERSION := $(shell gitversion /showvariable MajorMinorPatch)
ifeq ($(VERSION),)
    VERSION := 0.0.1
    NEXT_VERSION := 0.0.1
endif

version:
	@echo "Current version: $(VERSION)"
	@echo "Next version: $(NEXT_VERSION)"

release:
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "There are uncommitted changes or untracked files"; \
		exit 1; \
	fi
	@if [ "$$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then \
		echo "Not on main branch"; \
		exit 1; \
	fi
	@if [ "$$(git rev-parse HEAD)" != "$$(git rev-parse origin/main)" ]; then \
		echo "Local branch is ahead of origin"; \
		exit 1; \
	fi
	sed -i '' 's/version ".*"/version "$(NEXT_VERSION)"/' Formula/op-env.rb && \
	git add Formula/op-env.rb && \
	git commit -m "chore: update Formula version to $(NEXT_VERSION)" && \
	git tag v$(NEXT_VERSION) && \
	git push origin main --tags
