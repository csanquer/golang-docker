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

SERVICE = golang
# default shell options
.SHELLFLAGS = -c

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
default: all;   # default target

all:
	$(MAKE) rm
	$(MAKE) pull
	$(MAKE) build
	$(MAKE) up
.PHONY: all

volumes:
	mkdir -p volumes/go_src
.PHONY: volumes

env: volumes
	if [ ! -f .env  ]; then  cp .env.dist .env ; fi
.PHONY: env

pull: env
	$(ENV) $(DKC) pull
.PHONY: pull

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
	$(ENV) $(DKC) logs -f $(SERVICE)
.PHONY: logs

run_cli:
	$(ENV) $(DKC) run --rm $(SERVICE) bash
.PHONY: run_cli

exec_cli:
	$(ENV) $(DKC) exec $(SERVICE) bash
.PHONY: exec_cli
