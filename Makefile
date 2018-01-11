VERSION=$(shell cat VERSION)
SOURCE_FILES:=$(shell find src -type f)
TEST_FILES:=$(shell find test -type f)

.PHONY: clean
clean:
	rm -rf build

.PHONY: test
test: $(TEST_FILES)
	task/test -f tap test/**/*.sh

build: test kwm $(SOURCE_FILES)
	VERSION=$(VERSION) task/build

release: build
	VERSION=$(VERSION) task/create-release
	VERSION=$(VERSION) task/upload-artifact
	VERSION=$(VERSION) task/update-readme
