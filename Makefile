DOCKER_IMAGE ?= quay.io/democracyworks/infrastructure-ci
DOCKER_TAG = v1.5.0

AWSCLI_VERSION = 1.18.54
SAM_VERSION = 0.49.0
TF_VERSION = 0.12.25

.DEFAULT_GOAL := build

.PHONY: build push help

build:
	docker build --pull -t $(DOCKER_IMAGE):latest \
		--build-arg AWSCLI_VERSION=$(AWSCLI_VERSION) \
		--build-arg AWS_SAM_CLI_VERSION=$(SAM_VERSION) \
		--build-arg TERRAFORM_VERSION=$(TF_VERSION) \
		.

push: build
	docker tag $(DOCKER_IMAGE):latest $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

test: build
	docker run --rm $(DOCKER_IMAGE):latest aws --version | grep -s $(AWSCLI_VERSION)
	docker run --rm $(DOCKER_IMAGE):latest terraform version | grep -s $(TF_VERSION)
	docker run --rm $(DOCKER_IMAGE):latest sam --version | grep -s $(SAM_VERSION)

help:
	@echo "build: Build the Docker container."
	@echo "push: Push the Docker container to the container registry."
	@echo "test: Verify the container image."
	@echo "help: Display this message."
