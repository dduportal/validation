#!/bin/bash

set -eux -o pipefail

# Install make and Hugo inside the Ubuntu 22.04 environment using APT package manager
apt update --quiet
apt install --yes hugo=0.92* make=4*

# Check Hugo
hugo version

# Generates the website
make build
