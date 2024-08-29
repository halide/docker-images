FROM quay.io/pypa/manylinux_2_28_x86_64 AS base

WORKDIR /ws

## Install Ninja
RUN pipx install ninja==1.11.1.1

## Install flatbuffers
FROM base AS flatbuffers
ARG FB_VERSION=23.5.26
RUN git clone --depth 1 --branch v${FB_VERSION} https://github.com/google/flatbuffers.git && \
    cmake -G Ninja -S flatbuffers -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DFLATBUFFERS_BUILD_TESTS=OFF \
      && \
    cmake --build build --target install && \
    rm -rf flatbuffers build

## Install flatbuffers
FROM base AS wabt
ARG WABT_VERSION=1.0.36
RUN git clone --depth 1 --branch ${WABT_VERSION} https://github.com/WebAssembly/wabt.git && \
    git -C wabt submodule update --init third_party/picosha2 && \
    cmake -G Ninja -S wabt -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
      -DWITH_EXCEPTIONS=ON \
      -DBUILD_TESTS=OFF \
      -DBUILD_TOOLS=OFF \
      -DBUILD_LIBWASM=OFF \
      -DUSE_INTERNAL_SHA256=ON \
      && \
    cmake --build build --target install && \
    rm -rf wabt build

# Install LLVM
FROM base AS llvm
ARG LLVM_VERSION=18.1.8
RUN git clone --depth 1 --branch llvmorg-${LLVM_VERSION} https://github.com/llvm/llvm-project.git && \
    cmake -G Ninja -S llvm-project/llvm -B build \
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
    rm -rf llvm-project build

##
# Graft the final build products into a quay-derived manylinux image

FROM base

LABEL org.opencontainers.image.source=https://github.com/halide/docker-images

COPY --from=llvm /usr/local /usr/local
COPY --from=wabt /usr/local /usr/local
COPY --from=flatbuffers /usr/local /usr/local

