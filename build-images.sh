#!/bin/bash

set -e

if [ "$#" -ne 3 ]; then
  echo "You must specify the LLVM version as three arguments of the form MAJOR MINOR PATCH, e.g. ${0} 15 0 7"
  exit
fi

LLVM_MAJOR=$1
LLVM_MINOR=$2
LLVM_PATCH=$3

build_image() {
  ARCH="$1"
  docker build \
    -t "ghcr.io/halide/manylinux2014_$ARCH-llvm:$LLVM_MAJOR.$LLVM_MINOR.$LLVM_PATCH" \
    -t "ghcr.io/halide/manylinux2014_$ARCH-llvm:$LLVM_MAJOR.x" \
    --build-arg "LLVM_TAG=llvmorg-$LLVM_TAG" \
    --build-arg "ARCH=$ARCH" \
    .
}

build_image x86_64
build_image i686
build_image aarch64

echo "Complete! Now push the images with:"
echo "  docker push --all-tags ghcr.io/halide/manylinux2014_aarch64-llvm:$LLVM_MAJOR.$LLVM_MINOR.$LLVM_PATCH"
echo "  docker push --all-tags ghcr.io/halide/manylinux2014_i686-llvm:$LLVM_MAJOR.$LLVM_MINOR.$LLVM_PATCH"
echo "  docker push --all-tags ghcr.io/halide/manylinux2014_x86_64-llvm:$LLVM_MAJOR.$LLVM_MINOR.$LLVM_PATCH"
