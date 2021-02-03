FROM golang:1.15.8-buster AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Global setup
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PATH="/usr/local/go/bin:/opt/W3C-Validator:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Setup and install required dependencies
# updating apt cache is executed in a single instruction to avoid cache miss when rebuilding the image in the future
RUN apt-get update \
  # Install and setup the locale from environment variable
  && apt-get install -y --no-install-recommends \
    ca-certificates=202* \
    curl=7.* \
    locales=2.* \
  && locale-gen "${LANG}" \
  ## Add official nodejs distribution apt repository
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  # Install required packages
  && apt-get install -y --no-install-recommends \
    git=1:2.* \
    jq=1.* \
    make=4.* \
    nodejs=14.* \
    python3-pip=* \
    python3-setuptools=* \
    shellcheck=0.* \
    tar=1.* \
    unzip=6.* \
    zip=3.* \
  # Cleanup APT cache to ease extension of this image
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

## Install the hugo binary with a fixed version and control shasum
ARG HUGO_VERSION="0.80.0"
ARG HUGO_CHECKSUM="b3a259bbe633e2f9182f8ecfc1b5cee6a7cfc4c970defe5f29c9959f2ef3259b"
# Download the Linux 64 bits default archive
RUN curl --silent --show-error --location --output /tmp/hugo.tgz \
   "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
  # Control the checksum to ensure no one is messing up with the download
  && sha256sum /tmp/hugo.tgz | grep -q "${HUGO_CHECKSUM}" \
  # Extract to a directory part of the default PATH
  && tar xzf /tmp/hugo.tgz -C /usr/local/bin/ \
  # Sanity check
  && hugo version | grep "${HUGO_VERSION}" \
  # Cleanup
  && rm -f /tmp/hugo.tgz

## Install Custom Tools for Edx Modules
ARG GOLANGCILINT_VERSION="1.36.0"
ARG GOLANGCILINT_CHECKSUM="c36e9c7153e87dabcbc424c3a86b32676631ab94db4b5d7d2907675aea5c6709"
RUN curl --silent --show-error --location --output /tmp/golangci-lint.deb \
    "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-linux-amd64.deb" \
    # Control the checksum to ensure no one is messing up with the download
  && sha256sum /tmp/golangci-lint.deb | grep -q "${GOLANGCILINT_CHECKSUM}" \
  # Extract to a directory part of the default PATH
  && dpkg -i /tmp/golangci-lint.deb \
  # Sanity check
  && golangci-lint version 2>&1 | grep -q "${GOLANGCILINT_VERSION}" \
  # Cleanup
  && rm -f /tmp/golangci-lint.deb

RUN npm install --global \
  markdownlint-cli@0.26.0 \
  markdown-link-check@3.8.6

RUN python3 -m pip install --no-cache-dir \
  requests==2.* yamllint==1.*

RUN git clone https://github.com/holbertonschool/W3C-Validator.git /opt/W3C-Validator \
  # Sanity check
  && command -v w3c_validator.py


# Install Docker tools
ARG HADOLINT_VERSION=1.23.0
ARG HADOLINT_SHA256="bab0ec0840eebea519be0c507ef50354719113f047899d1bcae17a6a6839c95a"
RUN curl --fail --silent --show-error --location --output /usr/local/bin/hadolint \
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
  && sha256sum /usr/local/bin/hadolint | grep -q "${HADOLINT_SHA256}" \
  && chmod a+x /usr/local/bin/hadolint \
  && hadolint --version 2>&1 | grep "${HADOLINT_VERSION}"

ARG CST_VERSION=1.10.0
ARG CST_SHA256="72deeea26c990274725a325cf14acd20b8404251c4fcfc4d34b7527aac6c28bc"
RUN curl --fail --silent --show-error --location --output /usr/local/bin/container-structure-test \
    "https://storage.googleapis.com/container-structure-test/v${CST_VERSION}/container-structure-test-linux-amd64" \
  && sha256sum /usr/local/bin/container-structure-test | grep -q "${CST_SHA256}" \
  && chmod a+x /usr/local/bin/container-structure-test \
  && container-structure-test version 2>&1 | grep -q "${CST_VERSION}"

WORKDIR /app
COPY . /app/

ENV CGO_ENABLED=0
ENV GO11MODULES=on

##################################################################################################################################

FROM base AS lint
RUN golangci-lint run
RUN markdownlint README.md DEPLOY.md
RUN hadolint Dockerfile
RUN shellcheck ./*.sh

##################################################################################################################################

FROM base AS check
RUN find ./content -type f -name "*.md" -exec markdown-link-check {} \;
RUN markdownlint ./content/**/*.md

##################################################################################################################################

FROM base AS build
ARG binary_name=awesome-api
RUN hugo
RUN go build -o "${binary_name}"

##################################################################################################################################

FROM base as unit-tests
RUN go test -v -short -coverprofile=coverage-units.out

##################################################################################################################################

FROM build as integration-tests
RUN go test -v -coverprofile=coverage-integrations.out

##################################################################################################################################

FROM base as validate
# This instruction never fails
RUN w3c_validator.py ./dist/index.html || true

##################################################################################################################################

FROM alpine:3.13 AS app

RUN addgroup -S awesome && adduser -S awesome -G awesome -h /awesome

WORKDIR /awesome

COPY --from=build /app/dist /awesome/dist
COPY --from=build /app/awesome-api /awesome/awesome-api

ENV PORT=9999
EXPOSE $PORT

USER awesome

ENTRYPOINT []
CMD [ "/awesome/awesome-api" ]
