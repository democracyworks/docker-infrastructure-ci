DOCKER_IMAGE ?= 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci
DOCKER_TAG ?= v2.1.0

AWSCLI_VERSION = 2.1.1
SAM_VERSION = 1.10.0
TF_VERSION = 0.13.5

.DEFAULT_GOAL := build

.PHONY: build push help

build:
	docker build --pull -t "$(DOCKER_IMAGE):$(DOCKER_TAG)" \
		--build-arg AWSCLI_VERSION="$(AWSCLI_VERSION)" \
		--build-arg AWS_SAM_CLI_VERSION="$(SAM_VERSION)" \
		--build-arg TERRAFORM_VERSION="$(TF_VERSION)" \
		.

push: build
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

test: build
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) aws --version | grep -s $(AWSCLI_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) terraform version | grep -s $(TF_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) sam --version | grep -s $(SAM_VERSION)

help:
	@echo "build: Build the Docker container."
	@echo "push: Push the Docker container to the container registry."
	@echo "test: Verify the container image."
	@echo "help: Display this message."
