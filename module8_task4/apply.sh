#!/bin/bash

set -eu -o pipefail

docker cp ./manifests/* "$(docker-compose ps -q puppet)":/etc/puppetlabs/code/environments/production/manifests/

set +e
docker-compose exec -T node01 puppet agent --test 2>&1
RESULT=$?
set -e
if [ "${RESULT}" -ne 0 ] && [ "${RESULT}" -ne 2 ]
then
  exit "${RESULT}"
fi
