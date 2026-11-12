ZIRAN ?= ziran
LOCKED := $(if $(wildcard ziran.local.toml),,--locked)

.PHONY: check test
check:
	$(ZIRAN) check --project $(LOCKED)

test: check
	$(ZIRAN) build --project $(LOCKED) --target=c --exe --entry mermaid_test:main -o build/test-c tests/mermaid_test.zi
	build/test-c/mermaid_test
	$(ZIRAN) build --project $(LOCKED) --target=go --pkg main --exe --entry mermaid_test:main -o build/test-go tests/mermaid_test.zi
	cd build/test-go && GO111MODULE=off go build -o mermaid_test .
	build/test-go/mermaid_test
	$(ZIRAN) bundle --project $(LOCKED) --entry mermaid_test:main -o build/mermaid-test.zx tests/mermaid_test.zi
	$(ZIRAN) run --project $(LOCKED) --vm build/mermaid-test.zx
