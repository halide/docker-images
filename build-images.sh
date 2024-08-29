#!/bin/bash

set -eo pipefail

[[ "$1" == "" ]] && echo "You must specify the LLVM version as an argument, e.g. 17.0.6" && exit

LLVM_VERSION="$1"
LLVM_VERSION_MAJOR="${LLVM_VERSION%%.*}"

build_image () {
  IMAGE="$1"; shift
  docker build \
    --tag "ghcr.io/halide/$IMAGE:$LLVM_VERSION" \
    --tag "ghcr.io/halide/$IMAGE:$LLVM_VERSION_MAJOR" \
    --build-arg "LLVM_VERSION=$LLVM_VERSION" \
    "$@" \
    "$IMAGE"
}

build_image manylinux_2_28_x86_64-llvm
