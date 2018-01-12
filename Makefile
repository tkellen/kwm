VERSION:=$(shell cat VERSION)
SOURCE_FILES:=$(shell find src -type f)
TEST_FILES:=$(shell find test -type f)

export VERSION

test: $(TEST_FILES)
	env -i TERM=${TERM} task/test -f tap $(TEST_FILES)

.PHONY: test
build: test kwm $(SOURCE_FILES)
	task/build

release: build
	task/create-release
	task/upload-artifact
	task/update-readme

.PHONY: clean
clean:
	rm -rf build
