FROM debian:latest
LABEL maintainer="Democracy Works, Inc. <dev@democracy.works>"

ARG DEBIAN_FRONTEND=noninteractive

ARG AWSCLI_VERSION
ARG AWS_SAM_CLI_VERSION
ARG TERRAFORM_VERSION

RUN apt-get update\
  && apt-get -y install --no-install-recommends \
    curl \
    git \
    gnupg \
    jq \
    make \
    openssh-client \
    python3-pip \
    python3-setuptools \
    unzip \
  && curl -sSL https://keybase.io/hashicorp/pgp_keys.asc | gpg --import \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig \
  && gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep -s "${TERRAFORM_VERSION}_linux_amd64.zip: OK" \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && pip3 install \
    aws-sam-cli==${AWS_SAM_CLI_VERSION} \
    awscli==${AWSCLI_VERSION} \
  && rm -rf terraform_* \
  && rm -rf /var/lib/apt/lists/*
