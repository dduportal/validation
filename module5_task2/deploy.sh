#!/bin/bash

set -eux -o pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
cd "${script_dir}/"

## If a remote machine is used, then copy Prometheus's
# configuration file on it
compose_cmd=("docker-compose")
if test "${DOCKER_HOST:-notexisting}" != "notexisting"
then
  ssh_host="$(echo "${DOCKER_HOST}" | cut -d/ -f3,4)"
  echo "== Remote Docker Engine detected: copying files to remote machine"
  rsync -av "${script_dir}/" "${ssh_host}:~/"
  compose_cmd=("ssh" "${ssh_host}" "docker-compose")
else
  echo "== Docker Engine is local: assuming local files"
fi

## Cleanup previous containers and images if it already exists
docker ps -q | xargs docker kill || true
docker system prune --volumes --force

## Deploy with compose
"${compose_cmd[@]}" pull
"${compose_cmd[@]}" up --detach --no-build
