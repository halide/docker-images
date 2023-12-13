ARG ARCH=x86_64

FROM quay.io/pypa/manylinux2014_$ARCH

WORKDIR /ws

## Install Ninja
RUN \
    git clone --depth 1 --branch v1.11.1 https://github.com/ninja-build/ninja.git && \
    cmake -S ninja -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --target install -j "$(nproc)" && \
    rm -rf ninja build

## Install ZLIB
ARG ZLIB_TAG=v1.3
RUN git clone --depth 1 --branch "$ZLIB_TAG" https://github.com/madler/zlib.git && \
    cmake -G Ninja -S zlib -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    cmake --build build --target install && \
    rm -rf zlib build && \
    rm -f /usr/local/lib/libz.so*

## Install LLVM
ARG LLVM_TAG=llvmorg-17.0.6
RUN git clone --depth 1 --branch "$LLVM_TAG" https://github.com/llvm/llvm-project.git
RUN cmake \
      -G Ninja \
      -S llvm-project/llvm \
      -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_BUILD_32_BITS=OFF \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_BINDINGS=OFF \
      -DLLVM_ENABLE_CURL=OFF \
      -DLLVM_ENABLE_DIA_SDK=OFF \
      -DLLVM_ENABLE_EH=ON \
      -DLLVM_ENABLE_HTTPLIB=OFF \
      -DLLVM_ENABLE_IDE=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF \
      -DLLVM_ENABLE_OCAMLDOC=OFF \
      -DLLVM_ENABLE_PROJECTS="clang;lld" \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_WARNINGS=OFF \
      -DLLVM_ENABLE_ZLIB=ON \
      -DLLVM_ENABLE_ZSTD=OFF \
      -DLLVM_INCLUDE_BENCHMARKS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_TESTS=OFF \
      -DLLVM_TARGETS_TO_BUILD="X86;ARM;NVPTX;AArch64;Hexagon;PowerPC;WebAssembly" \
      && \
    cmake --build build --target install && \
    rm -rf llvm-project build
