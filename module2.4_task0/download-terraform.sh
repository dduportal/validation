#!/bin/bash

set -eux -o pipefail

echo "OK" > /usr/local/bin/terraform
chmod a+x /usr/local/bin/terraform
