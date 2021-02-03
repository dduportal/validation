#!/bin/bash

set -eu -o pipefail

export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

sudo apt-get update
# Install and setup the locale from environment variable
sudo apt-get install -y --no-install-recommends \
  ca-certificates=2021* \
  curl=7.* \
  locales=2.*

sudo locale-gen "${LANG}"

## Add official nodejs distribution apt repository
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -

## Install required packages
sudo apt-get install -y --no-install-recommends \
  git=1:2.* \
  make=4.* \
  nodejs=14.* \
  python3-pip=9.* \
  shellcheck=0.* \
  tar=1.* \
  unzip=6.*

## Install the Hugo v0.80 version
HUGO_VERSION="0.80.0"
HUGO_CHECKSUM="b3a259bbe633e2f9182f8ecfc1b5cee6a7cfc4c970defe5f29c9959f2ef3259b"
curl --silent --show-error --location --output /tmp/hugo.tgz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"
# Control the checksum to ensure no one is messing up with the download
sha256sum /tmp/hugo.tgz | grep -q "${HUGO_CHECKSUM}"
# Extract to a directory part of the default PATH
sudo tar xzf /tmp/hugo.tgz -C /usr/local/bin/
# Cleanup
rm -f /tmp/hugo.tgz


## Install Golang from binaryls  distribution
GO_VERSION="1.15.7"
GO_CHECKSUM="0d142143794721bb63ce6c8a6180c4062bcf8ef4715e7d6d6609f3a8282629b3"
curl --silent --show-error --location --output /tmp/go.tgz "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
# Control the checksum to ensure no one is messing up with the download
sha256sum /tmp/go.tgz | grep -q "${GO_CHECKSUM}"
# Extract to a directory part of the default PATH
sudo tar -C /usr/local -xzf /tmp/go.tgz
# Expose the binaries to all users
sudo ln -s /usr/local/go/bin/* /usr/local/bin/
# Cleanup
rm -f /tmp/go.tgz


## Install Custom tools
GOLANGCILINT_VERSION="1.36.0"
GOLANGCILINT_CHECKSUM="c36e9c7153e87dabcbc424c3a86b32676631ab94db4b5d7d2907675aea5c6709"
curl --silent --show-error --location --output /tmp/golangci-lint.deb \
   "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCILINT_VERSION}/golangci-lint-${GOLANGCILINT_VERSION}-linux-amd64.deb"
# Control the checksum to ensure no one is messing up with the download
sha256sum /tmp/golangci-lint.deb | grep -q "${GOLANGCILINT_CHECKSUM}"
# Extract to a directory part of the default PATH
sudo dpkg -i /tmp/golangci-lint.deb
# Cleanup
rm -f /tmp/golangci-lint.deb

sudo npm install --global "markdownlint-cli@0.26.0" "markdown-link-check@3.8.6"

sudo python3 -m pip install --no-cache-dir "requests==2.*" "yamllint==1.*"

git clone https://github.com/holbertonschool/W3C-Validator.git
sudo mv ./W3C-Validator/* /usr/local/bin/
rm -rf ./W3C-Validator

# Sanity check, as current user (no sudo, no root)
go version | grep "${GO_VERSION}"
command -v w3c_validator.py
golangci-lint version 2>&1 | grep -q "${GOLANGCILINT_VERSION}"
