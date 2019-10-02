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

# Build Docker image
build:
	$(C_APP) build --tag $(PROJ):$(TAG) .

# Create Python virtual environment
venv:
	python3 -m venv $(VENV)

# Install Python dependencies to the virtual environment
deps: venv
	. $(VENV)/bin/activate && \
		pip install --requirement requirements.txt

# Migrate the Django database
migrate: deps
	[[ -d $(DB_PATH) ]] || mkdir $(DB_PATH)
	. $(VENV)/bin/activate && \
		./manage.py migrate

# Run the Docker image
run: migrate build
	$(C_APP) run \
		--interactive \
		--tty \
		--rm \
		--name $(PROJ) \
		--publish 8080:8080 \
		--volume ${PWD}/storage:/tom/storage \
		$(PROJ):$(TAG)
