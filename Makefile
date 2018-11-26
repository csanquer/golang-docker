# set default shell
SHELL := $(shell which bash)
GROUP_ID = $(shell id -g)
USER_ID = $(shell id -u)
GROUPNAME =  dev
USERNAME = dev
HOMEDIR = /home/$(USERNAME)

ENV = /usr/bin/env
DKC = docker-compose
DK = docker
# default shell options
.SHELLFLAGS = -c

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: all;   # default target

.PHONY: all volumes env build stop rm _rm prune _upd

volumes:
	mkdir -p volumes/go_src
.PHONY: volumes

env: volumes
	if [ ! -f .env  ]; then  cp .env.dist .env ; fi
.PHONY: env

# unit tests with docker
build: env
	$(ENV) $(DKC) build
.PHONY: build

stop: env
	$(ENV) $(DKC) stop
.PHONY: stop

rm:
	$(ENV) $(DKC) rm -f -s -v
.PHONY: rm

prune: env
	$(ENV) $(DKC) down -v --remove-orphans
.PHONY: prune

up: env
up: _upd
up: ps
.PHONY: up

_upd: env
	$(ENV) $(DKC) up -d --remove-orphans
.PHONY: _upd

ps: env
	$(ENV) $(DKC) ps
.PHONY: ps

logs:
	$(ENV) $(DKC) logs -f  golang
.PHONY: logs

cli:
	$(ENV) $(DKC) run --rm golang bash
.PHONY: cli
