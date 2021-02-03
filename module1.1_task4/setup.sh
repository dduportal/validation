#!/bin/bash

set -eux -o pipefail

## Install Make from default package manager as the version requirement is already met
apt-get update
apt-get install -y make curl

## Install the Hugo v0.80 version
HUGO_VERSION="0.80.0"
HUGO_CHECKSUM="b3a259bbe633e2f9182f8ecfc1b5cee6a7cfc4c970defe5f29c9959f2ef3259b"
curl --silent --show-error --location --output /tmp/hugo.tgz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"

# Control the checksum to ensure no one is messing up with the download
sha256sum /tmp/hugo.tgz | grep -q "${HUGO_CHECKSUM}"

# Extract to a directory part of the default PATH
tar xzf /tmp/hugo.tgz -C /usr/local/bin/

# Cleanup
rm -f /tmp/hugo.tgz

echo INSTALLED

make build
