ARG ARCH=x86_64
FROM quay.io/pypa/manylinux2014_$ARCH

WORKDIR /ws

## Install wget
RUN yum -y install wget

## Install Ninja
RUN git clone --depth 1 --branch v1.12.1 https://github.com/ninja-build/ninja.git && \
    cmake -S ninja -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF && \
    cmake --build build --target install -j "$(nproc)" && \
    rm -rf ninja build

## Install flatbuffers
ARG FB_VERSION=23.5.26
RUN wget -q https://github.com/google/flatbuffers/archive/refs/tags/v${FB_VERSION}.tar.gz && \
    tar xvf v${FB_VERSION}.tar.gz && \
    rm v${FB_VERSION}.tar.gz && \
    cmake -G Ninja -S flatbuffers-${FB_VERSION} -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DFLATBUFFERS_BUILD_TESTS=OFF \
      && \
    cmake --build build --target install && \
    rm -rf flatbuffers-${FB_VERSION} build

## Install flatbuffers
ARG WABT_VERSION=1.0.36
RUN git clone --recursive --depth 1 --branch ${WABT_VERSION} https://github.com/WebAssembly/wabt.git && \
    cmake -G Ninja -S wabt -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DWITH_EXCEPTIONS=ON \
      -DBUILD_TESTS=OFF \
      -DBUILD_TOOLS=OFF \
      -DBUILD_LIBWASM=OFF \
      -DUSE_INTERNAL_SHA256=ON \
      && \
    cmake --build build --target install && \
    rm -rf wabt build

## Install LLVM
ARG LLVM_TAG=llvmorg-18.1.8
RUN wget -q https://github.com/llvm/llvm-project/archive/refs/tags/${LLVM_TAG}.tar.gz && \
    tar xf ${LLVM_TAG}.tar.gz && \
    rm ${LLVM_TAG}.tar.gz && \
    cmake -G Ninja -S llvm-project-${LLVM_TAG}/llvm -B build \
      "-DLLVM_ENABLE_PROJECTS=clang;lld" \
      "-DLLVM_ENABLE_RUNTIMES=compiler-rt" \
      "-DLLVM_TARGETS_TO_BUILD=WebAssembly;X86;AArch64;ARM;Hexagon;NVPTX;PowerPC;RISCV" \
      -DCMAKE_BUILD_TYPE=Release \
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
    rm -rf llvm-project-${LLVM_TAG} build
