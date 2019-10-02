PROJ := dockertom

VENV := tom_env

DB_PATH := storage

C_APP := docker

GIT_DIRTY := $(shell git status --porcelain)
GIT_TAG := $(shell git describe --always)

# Add a suffix to the tag if the repo is dirty
ifeq ($(GIT_DIRTY),)
TAG := $(GIT_TAG)
else
TAG := $(GIT_TAG)-dirty
endif

all: run

build:
	$(C_APP) build --tag $(PROJ):$(TAG) .

venv:
	python3 -m venv $(VENV)

migrate:
	[[ -d $(DB_PATH) ]] || mkdir $(DB_PATH)
	./manage.py migrate

run: migrate build
	$(C_APP) run \
		--interactive \
		--tty \
		--rm \
		--name $(PROJ) \
		--publish 8080:8080 \
		--volume ${PWD}/storage:/tom/storage \
		$(PROJ):$(TAG)
