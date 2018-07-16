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

env: volumes
	if [ ! -f .env  ]; then  cp .env.dist .env ; fi

# unit tests with docker
build: env
	$(ENV) $(DKC) build

stop: env
	$(ENV) $(DKC) stop

rm: stop
rm: _rm

_rm: env
	$(ENV) $(DKC) rm -f -v

prune: env
	$(ENV) $(DKC) down -v --remove-orphans

up: env
up: _upd
up: ps

_upd: env
	$(ENV) $(DKC) up -d --remove-orphans

ps: env
	$(ENV) $(DKC) ps
