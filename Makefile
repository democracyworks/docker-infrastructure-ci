DOCKER_IMAGE ?= 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci
DOCKER_TAG ?= v3.0.0-alpha1

AWSCLI_VERSION = 2.1.29
KUBECTL_VERSION = 1.19.8
KUBEVAL_VERSION = 0.15.0
SAM_VERSION = 1.20.0
TF_VERSION = 0.14.7

.DEFAULT_GOAL := build

.PHONY: build
build:
	docker build -t "$(DOCKER_IMAGE):$(DOCKER_TAG)" \
		--build-arg AWSCLI_VERSION="$(AWSCLI_VERSION)" \
		--build-arg AWS_SAM_CLI_VERSION="$(SAM_VERSION)" \
		--build-arg KUBECTL_VERSION="$(KUBECTL_VERSION)" \
		--build-arg KUBEVAL_VERSION="$(KUBEVAL_VERSION)" \
		--build-arg TERRAFORM_VERSION="$(TF_VERSION)" \
		.

.PHONY: push
push: build
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: test
test: build
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) aws --version | grep -s $(AWSCLI_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) kubectl version --client | grep -s $(KUBECTL_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) kubeval --version | grep -s $(KUBEVAL_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) terraform version | grep -s $(TF_VERSION)
	docker run --rm $(DOCKER_IMAGE):$(DOCKER_TAG) sam --version | grep -s $(SAM_VERSION)

.PHONY: help
help:
	@echo "build: Build the Docker container."
	@echo "push: Push the Docker container to the container registry."
	@echo "test: Verify the container image."
	@echo "help: Display this message."
