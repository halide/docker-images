#!/bin/bash

set -e

##
# Remove all containers

read -ra containers < <(docker ps -qa) || true
if ((${#containers[@]} != 0)); then
  echo "Removing containers: ${containers[*]}..."
  docker stop "${containers[@]}"
  docker rm "${containers[@]}"
else
  echo "No containers to remove"
fi

##
# Remove all images

docker image prune

read -ra images < <(docker images -qa) || true
if ((${#images[@]} != 0)); then
  echo "Removing images: ${images[*]}..."
  docker rmi -f "${images[@]}"
else
  echo "No images to remove"
fi

##
# Remove all volumes

read -ra volumes < <(docker volume ls -q) || true
if ((${#volumes[@]} != 0)); then
  echo "Removing volumes: ${volumes[*]}..."
  docker volume rm "${volumes[@]}"
else
  echo "No volumes to remove"
fi
