FROM quay.io/pypa/manylinux2014_x86_64

WORKDIR /ws

## Install Ninja
RUN curl -LO https://github.com/ninja-build/ninja/releases/download/v1.11.0/ninja-linux.zip && \
    unzip -o ninja-linux.zip -d /usr/local/bin && \
    rm -f ninja-linux.zip

## Install ZLIB
ARG ZLIB_TAG=v1.2.12
RUN git clone --depth 1 --branch $ZLIB_TAG https://github.com/madler/zlib.git && \
    cmake -G Ninja -S zlib -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    cmake --build build --target install && \
    rm -rf zlib build && \
    rm -f /usr/local/lib/libz.so*

## Install LLVM
#ARG LLVM_TAG=llvmorg-14.0.6
#RUN git clone --depth 1 --branch $LLVM_TAG https://github.com/llvm/llvm-project.git && \
#    cmake -G Ninja -S llvm-project/llvm -B build -DCMAKE_BUILD_TYPE=Release \
#      -DLLVM_ENABLE_PROJECTS="clang;lld" \
#      -DLLVM_TARGETS_TO_BUILD="X86;ARM;NVPTX;AArch64;Mips;Hexagon;WebAssembly" \
#      -DLLVM_BUILD_32_BITS=OFF \
#      -DLLVM_ENABLE_ASSERTIONS=ON \
#      -DLLVM_ENABLE_EH=ON \
#      -DLLVM_ENABLE_LIBXML2=OFF \
#      -DLLVM_ENABLE_RTTI=ON \
#      -DLLVM_ENABLE_TERMINFO=OFF \
#      -DLLVM_ENABLE_ZSTD=OFF &&\
#    cmake --build build --target install && \
#    rm -rf llvm-project build
