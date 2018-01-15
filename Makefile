TEST_FILES:=$(shell find test -type f)
VERSION:=$(shell cat VERSION)
SHA:=$(shell git rev-parse --short HEAD)

export VERSION SHA

.PHONY: test
test:
	@env -i TERM=${TERM} task/test -f tap $(TEST_FILES)

.PHONY: clean
clean:
	@rm -rf build

build: test
	@task/build

release: build
	@task/release
