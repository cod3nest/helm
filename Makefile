ROOT_DIR="$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/"

all: build publish

build: build-arm

build-arm:
	docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64 .

publish:
	./publish.sh ;

.PHONY: shellcheck
