ARG ARCH=x86_64
FROM messense/manylinux_2_28-cross:$ARCH 

LABEL org.opencontainers.image.source=https://github.com/halide/docker-images

WORKDIR /ws

## Install Ninja
ARG NINJA_VERSION=v1.12.1
RUN git clone --depth 1 --branch ${NINJA_VERSION} https://github.com/ninja-build/ninja.git && \
    cmake -S ninja -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF && \
    cmake --build build --target install -j "$(nproc)" && \
    rm -rf ninja build

## Install flatbuffers
ARG FB_VERSION=v23.5.26
RUN git clone --depth 1 --branch ${FB_VERSION} https://github.com/google/flatbuffers.git && \
    cmake -G Ninja -S flatbuffers -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER=$TARGET_CC \
      -DCMAKE_CXX_COMPILER=$TARGET_CXX \
      -DFLATBUFFERS_BUILD_TESTS=OFF \
      && \
    cmake --build build --target install && \
    rm -rf flatbuffers build

## Install flatbuffers
ARG WABT_VERSION=1.0.36
RUN git clone --depth 1 --branch ${WABT_VERSION} https://github.com/WebAssembly/wabt.git && \
    git -C wabt submodule update --init third_party/picosha2 && \
    cmake -G Ninja -S wabt -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER=$TARGET_CC \
      -DCMAKE_CXX_COMPILER=$TARGET_CXX \
      -DWITH_EXCEPTIONS=ON \
      -DBUILD_TESTS=OFF \
      -DBUILD_TOOLS=OFF \
      -DBUILD_LIBWASM=OFF \
      -DUSE_INTERNAL_SHA256=ON \
      && \
    cmake --build build --target install && \
    rm -rf wabt build

# Install LLVM
ARG LLVM_TAG=llvmorg-18.1.8
RUN git clone --depth 1 --branch ${LLVM_TAG} https://github.com/llvm/llvm-project.git && \
    cmake -G Ninja -S llvm-project/llvm -B build \
      "-DLLVM_ENABLE_PROJECTS=clang;lld" \
      "-DLLVM_ENABLE_RUNTIMES=compiler-rt" \
      "-DLLVM_TARGETS_TO_BUILD=WebAssembly;X86;AArch64;ARM;Hexagon;NVPTX;PowerPC;RISCV" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER=$TARGET_CC \
      -DCMAKE_CXX_COMPILER=$TARGET_CXX \
      -DLLVM_BUILD_32_BITS=OFF \
      -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_BINDINGS=OFF \
      -DLLVM_ENABLE_CURL=OFF \
      -DLLVM_ENABLE_DIA_SDK=OFF \
      -DLLVM_ENABLE_EH=ON \
      -DLLVM_ENABLE_HTTPLIB=OFF \
      -DLLVM_ENABLE_IDE=OFF \
      -DLLVM_ENABLE_LIBEDIT=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF \
      -DLLVM_ENABLE_OCAMLDOC=OFF \
      -DLLVM_ENABLE_RTTI=ON \
      -DLLVM_ENABLE_TERMINFO=OFF \
      -DLLVM_ENABLE_WARNINGS=OFF \
      -DLLVM_ENABLE_ZLIB=OFF \
      -DLLVM_ENABLE_ZSTD=OFF \
      -DLLVM_INCLUDE_BENCHMARKS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_TESTS=OFF \
      && \
    cmake --build build --target install && \
    rm -rf llvm-project build
