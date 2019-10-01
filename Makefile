DOCKER_IMG := dockertom

DB_VOL := tom-db

GIT_DIRTY := $(shell git status --porcelain)
GIT_TAG := $(shell git describe --always)

# Add a suffix to the tag if the repo is dirty
ifeq ($(GIT_DIRTY),)
TAG := $(GIT_TAG)
else
TAG := $(GIT_TAG)-dirty
endif

all: docker-build

docker-build:
	docker build --tag $(DOCKER_IMG):$(TAG) .

run:
	docker run -it --rm --name dockertom --publish 8080:8080 --volume ${HOME}/workspace/lco/tom/dockertom/storage:/tom/storage dockertom:$(TAG)
