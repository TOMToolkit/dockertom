PROJ := dockertom

DB_VOL := tom-db

GIT_DIRTY := $(shell git status --porcelain)
GIT_TAG := $(shell git describe --always)

# Add a suffix to the tag if the repo is dirty
ifeq ($(GIT_DIRTY),)
TAG := $(GIT_TAG)
else
TAG := $(GIT_TAG)-dirty
endif

all: build

build:
	docker build --tag $(PROJ):$(TAG) .

migrate:
	./manage.py migrate

run: migrate
	docker run \
		--interactive \
		--tty \
		--rm \
		--name $(PROJ) \
		--publish 8080:8080 \
		--volume ${PWD}/storage:/tom/storage \
		$(PROJ):$(TAG)
