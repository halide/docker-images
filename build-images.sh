#!/bin/bash

set -eo pipefail

[[ "$1" == "" ]] && echo "You must specify the LLVM version as an argument, e.g. 17.0.6" && exit

LLVM_TAG=$1

docker build \
  --tag "ghcr.io/halide/manylinux_2_28_aarch64-llvm:$LLVM_TAG" \
  --build-arg "LLVM_TAG=llvmorg-$LLVM_TAG" \
  --build-arg "ARCH=aarch64" \
  .

docker build \
  --tag "ghcr.io/halide/manylinux_2_28_x86_64-llvm:$LLVM_TAG" \
  --build-arg "LLVM_TAG=llvmorg-$LLVM_TAG" \
  --build-arg "ARCH=x86_64" \
  .

