## GHDL ##

FROM symbiyosys as symbiyosys-ghdl

ARG LLVM_VER="7"
ARG GNAT_VER="8"

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    gnat \
    zlib1g-dev \
    llvm-dev && \
    apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# Build GHDL
RUN cd /root && \
    mkdir ghdl && \
    cd ghdl && \
    curl https://codeload.github.com/ghdl/ghdl/tar.gz/master | tar xzf - --strip-components=1 && \
    ./configure --enable-synth --prefix=/opt/ghdl --with-llvm-config=llvm-config-$LLVM_VER && \
    make && \
    make install


## GHDLSYNTH-BETA ##

FROM symbiyosys-ghdl AS symbiyosys-ghdlsynth

# Build ghdlsynth-beta
RUN cd /root && \
    mkdir ghdlsynth-beta && \
    cd ghdlsynth-beta && \
    curl https://codeload.github.com/tmeissner/ghdlsynth-beta/tar.gz/tests | tar xzf - --strip-components=1 && \
    make GHDL=/opt/ghdl/bin/ghdl YOSYS_CONFIG=/opt/yosys/bin/yosys-config && \
    make install GHDL=/opt/ghdl/bin/ghdl YOSYS_CONFIG=/opt/yosys/bin/yosys-config


# GHDL-formal

FROM debian:buster-slim AS ghdl-formal

# Get runtime dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    libreadline7 \
    libtcl8.6 \
    libgnat-8 \
    make \
    python3 && \
    apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# copy build artifacts
COPY --from=symbiyosys-ghdlsynth /opt/ghdl /opt/ghdl
COPY --from=symbiyosys-ghdlsynth /opt/symbiyosys /opt/symbiyosys
COPY --from=symbiyosys-ghdlsynth /opt/yosys /opt/yosys
COPY --from=symbiyosys-ghdlsynth /opt/z3 /opt/z3
COPY --from=symbiyosys-ghdlsynth /opt/yices2 /opt/yices2
COPY --from=symbiyosys-ghdlsynth /opt/cvc4 /opt/cvc4
COPY --from=symbiyosys-ghdlsynth /opt/boolector /opt/boolector

# Enhance path variable
ENV PATH "/opt/ghdl/bin:/opt/symbiyosys/bin:/opt/yosys/bin:/opt/z3/bin:/opt/yices2/bin:/opt/cvc4/bin:/opt/boolector/bin:$PATH"
