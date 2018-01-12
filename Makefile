VERSION:=$(shell cat VERSION)
SOURCE_FILES:=$(shell find src -type f)
TEST_FILES:=$(shell find test -type f)

export VERSION

test: $(TEST_FILES)
	env -i TERM=${TERM} task/test -f tap $(TEST_FILES)

.PHONY: test
build: test kwm $(SOURCE_FILES)
	task/build

.PHONY: ensure-clean
ensure-clean:
	@git status --porcelain | grep -v VERSION && (echo "working tree is not clean"; exit 1) || true

release: ensure-clean build
	task/update-readme
	task/update-changelog
	git commit -a -m "[no-changelog] ${VERSION}"
	git push origin master
	task/create-release
	task/upload-artifact

.PHONY: clean
clean:
	rm -rf build
