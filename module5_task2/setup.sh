#!/bin/bash

set -eu -o pipefail

# Install Docker tools
HADOLINT_VERSION=1.23.0
HADOLINT_SHA256="bab0ec0840eebea519be0c507ef50354719113f047899d1bcae17a6a6839c95a"
curl --fail --silent --show-error --location --output /usr/local/bin/hadolint \
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
  && sha256sum /usr/local/bin/hadolint | grep -q "${HADOLINT_SHA256}" \
  && chmod a+x /usr/local/bin/hadolint \
  && hadolint --version 2>&1 | grep "${HADOLINT_VERSION}"

CST_VERSION=1.10.0
CST_SHA256="72deeea26c990274725a325cf14acd20b8404251c4fcfc4d34b7527aac6c28bc"
curl --fail --silent --show-error --location --output /usr/local/bin/container-structure-test \
    "https://storage.googleapis.com/container-structure-test/v${CST_VERSION}/container-structure-test-linux-amd64" \
  && sha256sum /usr/local/bin/container-structure-test | grep -q "${CST_SHA256}" \
  && chmod a+x /usr/local/bin/container-structure-test \
  && container-structure-test version 2>&1 | grep -q "${CST_VERSION}"

# AWS CLI
AWSCLI_VERSION=2.1.31
AWSCLI_SHA256="a98fe41219de0d7ce9142f2caf08a19eb3c8d05317696f06b1cc5d484b989b6f"
curl --silent --show-error --location --output /tmp/aws.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" \
&& sha256sum /tmp/aws.zip | grep -q "${AWSCLI_SHA256}" \
&& unzip /tmp/aws.zip -d /tmp \
&& bash /tmp/aws/install \
&& aws --version 2>&1 | grep -q "${AWSCLI_VERSION}" \
&& rm -rf /tmp/*

echo "Setup OK"
