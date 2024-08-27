#!/bin/bash

set -eo pipefail

[[ "$1" == "" ]] && echo "You must specify the LLVM version as an argument, e.g. 17.0.6" && exit

LLVM_TAG="$1"

build_arch () {
  ARCH="$1"
  docker build \
    --tag "ghcr.io/halide/manylinux_2_28_$ARCH-llvm:$LLVM_TAG" \
    --build-arg "LLVM_TAG=llvmorg-$LLVM_TAG" \
    --build-arg "ARCH=$ARCH" \
    .
}

build_arch aarch64
build_arch x86_64
