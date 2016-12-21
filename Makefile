# golang-client Makefile
# Follows the interface defined in the Golang CTI proposed
# in https://review.openstack.org/410355

#REPO_VERSION?=$(shell git describe --tags)

GIT_HOST = git.openstack.org

PWD := $(shell pwd)
TOP_DIR := $(shell basename $(PWD))
# Keep an existing GOPATH, make one up if it is undefined
export GOPATH ?= $(PWD)-gopath
DEST := $(GOPATH)/src/$(GIT_HOST)/openstack/$(TOP_DIR).git

env:
	@echo "PWD: $(PWD)"
	@echo "TOP_DIR: $(TOP_DIR)"
	@echo "GOPATH: $(GOPATH)"
	@echo "DEST: $(DEST)"

work: $(GOPATH) $(DEST)

$(GOPATH):
	mkdir -p $(GOPATH)

$(DEST): $(GOPATH)
	mkdir -p $(shell dirname $(DEST))
	ln -s $(PWD) $(DEST)

get: work
	cd $(DEST); go get -tags=unit -t ./...

test: get
	cd $(DEST); go test -tags=unit ./...

fmt:
	cd $(DEST); go fmt ./...

cover:
	@echo "$@ not yet implemented"

docs:
	@echo "$@ not yet implemented"

relnotes:
	@echo "Reno not yet implemented for this repo"

translation:
	@echo "$@ not yet implemented"

.bindep:
	virtualenv .bindep
	.bindep/bin/pip install bindep

bindep: .bindep
	@.bindep/bin/bindep -b -f bindep.txt || true

install-distro-packages:
	tools/install-distro-packages.sh

clean:
	rm -rf .bindep

.PHONY: bindep