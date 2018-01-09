VERSION=$(shell cat VERSION)
TEMPLATES:=$(shell find template -type f)

.PHONY: clean
clean:
	rm -rf build

build: kwm $(TEMPLATES)
	VERSION=$(VERSION) script/build

release: build
	VERSION=$(VERSION) script/create
	VERSION=$(VERSION) script/upload
