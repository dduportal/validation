#!/bin/bash

set -eux -o pipefail

script_dir="$(cd "$(dirname "$0")" && pwd -P)"
cd "${script_dir}/"

test -f "${script_dir}"/awesome-website.zip || { echo "ERROR: no archive file named awesome-website.zip found."; exit 1; }

## Retrieve the image name
container_name="awesome-web"

## Cleanup previous containers and images if it already exists
docker ps -q | xargs docker kill || true
docker system prune --volumes --force

## Load the new Docker Image
unzip -o awesome-website.zip
docker load --input ./docker-image.tar
new_docker_image=$(docker image ls | grep 'awesome' | sort | uniq | head -n1 | awk '{print $3}')

## Start the new container
docker container run --name="${container_name}" --publish 80:9999 --rm --detach "${new_docker_image}"
