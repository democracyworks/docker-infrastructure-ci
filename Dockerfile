FROM debian:latest
LABEL maintainer="Democracy Works, Inc. <dev@democracy.works>"

ARG DEBIAN_FRONTEND=noninteractive

ARG AWSCLI_VERSION
ARG AWS_SAM_CLI_VERSION
ARG TERRAFORM_VERSION

COPY awscli/awscli-public-key.asc /root/

RUN apt-get update \
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
  && cd /root \
  && curl -sSL https://keybase.io/hashicorp/pgp_keys.asc | gpg --import \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig \
  && gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep -s "${TERRAFORM_VERSION}_linux_amd64.zip: OK" \
  && unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && gpg --import awscli-public-key.asc \
  && curl -sSLo awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip \
  && curl -sSLo awscliv2.zip.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip.sig \
  && gpg --verify awscliv2.zip.sig awscliv2.zip \
  && unzip -q awscliv2.zip \
  && ./aws/install \
  && pip3 install --no-cache-dir \
    aws-sam-cli==${AWS_SAM_CLI_VERSION} \
  && rm -rf * \
  && rm -rf /var/lib/apt/lists/*
