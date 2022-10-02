#!/bin/bash

set -e

LLVM_TAG=${1:-15.0.1}

build_image() {
  ARCH="$1"
  docker build -t "ghcr.io/halide/manylinux2014_$ARCH-llvm:$LLVM_TAG" --build-arg "LLVM_TAG=llvmorg-$LLVM_TAG" --build-arg "ARCH=$ARCH" .
}

build_image x86_64
build_image i686
build_image aarch64
