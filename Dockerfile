FROM debian:latest AS build

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    unzip

WORKDIR /root

### Install Terraform

ARG TERRAFORM_VERSION
RUN curl -sSL https://keybase.io/hashicorp/pgp_keys.asc | gpg --import \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig \
  && gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS \
  && sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep -s "${TERRAFORM_VERSION}_linux_amd64.zip: OK" \
  && unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

### Install kubectl

ARG KUBECTL_VERSION
RUN curl -sSLo /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && chmod 0755 /usr/local/bin/kubectl

### Install kubeval

ARG KUBEVAL_VERSION
RUN mkdir -p kubeval \
  && curl -sSLO https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz \
  && tar -C kubeval -xzf kubeval-linux-amd64.tar.gz \
  && install -m 0755 kubeval/kubeval /usr/local/bin/kubeval

### Install AWS CLI v2

COPY awscli/awscli-public-key.asc /root/
ARG AWSCLI_VERSION
RUN gpg --import awscli-public-key.asc \
  && curl -sSLo awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip \
  && curl -sSLo awscliv2.zip.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip.sig \
  && gpg --verify awscliv2.zip.sig awscliv2.zip \
  && unzip -d awscliv2 -q awscliv2.zip \
  && ./awscliv2/aws/install --bin-dir /usr/local/aws-cli-bin

FROM debian:latest
LABEL maintainer="Democracy Works, Inc. <dev@democracy.works>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    git \
    jq \
    make \
    openssh-client \
    python3-pip \
    python3-setuptools \
    unzip \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=build /usr/local/aws-cli-bin/ /usr/local/bin/
COPY --from=build /usr/local/bin/ /usr/local/bin/

### Install the AWS SAM CLI

ARG AWS_SAM_CLI_VERSION
RUN pip3 install --no-cache-dir \
  aws-sam-cli==${AWS_SAM_CLI_VERSION}
