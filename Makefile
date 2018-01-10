VERSION=$(shell cat VERSION)
SOURCE_FILES:=$(shell find src -type f)
TEST_FILES:=$(shell find test -type f)

.PHONY: clean
clean:
	rm -rf build

.PHONY: test
test: $(TEST_FILES)
	tasks/test -f tap test/*.sh

build: test kwm $(SOURCE_FILES)
	VERSION=$(VERSION) tasks/build

release: build
	VERSION=$(VERSION) tasks/create-release
	VERSION=$(VERSION) tasks/upload-artifact
	VERSION=$(VERSION) tasks/update-readme
