VERSION=$(shell cat VERSION)
TEMPLATES:=$(shell find src/template -type f)

.PHONY: clean
clean:
	rm -rf build

build: kwm $(TEMPLATES)
	VERSION=$(VERSION) tasks/build

release: build
	VERSION=$(VERSION) tasks/create-release
	VERSION=$(VERSION) tasks/upload-artifact
	VERSION=$(VERSION) tasks/update-readme
