#!/bin/bash

set -eu -o pipefail

apt-get update
apt-get install -y hugo make

echo INSTALLED

make build
