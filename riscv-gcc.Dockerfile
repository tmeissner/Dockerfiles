# Dockerfile to build Risc-V toolchain for
# rv32i instruction set and ilp32 ABI
# Useful to compile for NEORV32 target

FROM debian:buster-slim as riscv-gcc

# Get dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    git && \
    apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    cd /root && \
    git clone https://github.com/riscv/riscv-gnu-toolchain &&\
    de riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv-gcc --with-arch=rv32i --with-abi=ilp32 && \
    make && \
    make clean
