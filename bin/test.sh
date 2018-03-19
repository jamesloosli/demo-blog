#!/bin/bash

set -ex

# Compatibility between local and travis environments
COMMIT_HASH=${TRAVIS_COMMIT+"$(git rev-parse HEAD)"}
set PATH=$PATH:./bin

# Check environment variables and packages
function check_pkg() {
  echo -n "Checking for executable $1 ... "
  if hash $1; then
    echo "Found"
  else
    exit 1
  fi
}

function check_env() {
  echo -n "Checking for env var $1 ... "
  varname=$1
  : ${!varname?"Need to set $varname"}
  : ${!varname?"Need to set $varname non-empty"}
  echo "Found"
}

packages="
  docker
  curl
"

env_vars="
  COMMIT_HASH
"

for package in $packages; do
  check_pkg $package
done

for env_var in $env_vars; do
  check_env $env_var
done

docker run -p 80:80 --rm ${DOCKER_USERNAME}/${REPO_NAME}:${COMMIT_HASH}
docker ps
sleep 3 && curl -s localhost | grep '<!doctype html>'
