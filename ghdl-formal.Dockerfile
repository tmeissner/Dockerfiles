## GHDL ##

FROM symbiyosys as symbiyosys-ghdl

ARG LLVM_VER="11"

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    gnat \
    llvm-dev && \
    apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    cd /root && \
    mkdir ghdl && \
    cd ghdl && \
    curl https://codeload.github.com/ghdl/ghdl/tar.gz/master | tar xzf - --strip-components=1 && \
    ./configure --enable-synth --prefix=/opt/ghdl --with-llvm-config=llvm-config-$LLVM_VER && \
    make && \
    make install && \
    mkdir /opt/ghdl/doc && \
    curl https://ghdl.readthedocs.io/_/downloads/en/latest/pdf/ -o /opt/ghdl/doc/ghdl_manual.pdf


## GHDLSYNTH-BETA ##

FROM symbiyosys-ghdl AS symbiyosys-ghdlsynth

# Build ghdlsynth-beta
RUN cd /root && \
    mkdir ghdl-yosys-plugin && \
    cd ghdl-yosys-plugin && \
    curl https://codeload.github.com/ghdl/ghdl-yosys-plugin/tar.gz/master | tar xzf - --strip-components=1 && \
    make GHDL=/opt/ghdl/bin/ghdl YOSYS_CONFIG=/opt/yosys/bin/yosys-config && \
    make install GHDL=/opt/ghdl/bin/ghdl YOSYS_CONFIG=/opt/yosys/bin/yosys-config


# GHDL-formal

FROM debian:bullseye-slim AS ghdl-formal

ARG LLVM_VER="11"

# Get runtime dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    libreadline8 \
    libtcl8.6 \
    libgnat-10 \
    libllvm$LLVM_VER \
    gcc \
    libc6-dev \
    zlib1g-dev \
    make \
    python3 \
    libssl-dev \
    libpython2.7 && \
    apt-get -y upgrade && apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# copy build artifacts
COPY --from=symbiyosys-ghdlsynth /opt /opt

# Enhance path variable
ENV PATH "/opt/ghdl/bin:/opt/symbiyosys/bin:/opt/yosys/bin:/opt/z3/bin:/opt/yices2/bin:/opt/cvc4/bin:/opt/boolector/bin:/opt/bitwuzla/bin:/opt/super_prove/bin:$PATH"
