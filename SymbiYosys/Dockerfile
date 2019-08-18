FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    clang \
    bison \
    flex \
    libreadline-dev \
    gawk \
    tcl-dev \
    libffi-dev \
    git \
    mercurial \
    graphviz \
    xdot \
    pkg-config \
    python \
    python3 \
    libftdi-dev \
    gperf \
    libboost-program-options-dev \
    autoconf \
    libgmp-dev \
    cmake \
    make \
    wget \
    libpython2.7 && \
    adduser symbiyosys --gecos "" --disabled-login

RUN cd /home/symbiyosys && \
    git clone https://github.com/cliffordwolf/yosys.git yosys && \
    cd yosys && \
    make -j$(nproc) && \
    make install && \
    cd /home/symbiyosys && \
    git clone https://github.com/cliffordwolf/SymbiYosys.git SymbiYosys && \
    cd SymbiYosys && \
    make install && \
    cd /home/symbiyosys && \
    git clone https://github.com/Z3Prover/z3.git z3 && \
    cd z3 && \
    python scripts/mk_make.py && \
    cd build && \
    make -j$(nproc) && \
    make install && \
    cd /home/symbiyosys && \
    git clone https://github.com/SRI-CSL/yices2.git yices2 && \
    cd yices2 && \
    autoconf && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd /home/symbiyosys && \
    git clone https://bitbucket.org/arieg/extavy.git && \
    cd extavy && \
    git submodule update --init && \
    mkdir build; cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && \
    cp avy/src/avy /usr/local/bin/ && \
    cp avy/src/avybmc /usr/local/bin/ && \
    cd /home/symbiyosys && \
    git clone https://github.com/boolector/boolector && \
    git clone https://github.com/arminbiere/lingeling boolector/deps/lingeling && \
    git clone https://github.com/boolector/btor2tools boolector/deps/btor2tools && \
    ( cd boolector/deps/lingeling  && ./configure.sh -fPIC && make -j$(nproc); ) && \
    ( cd boolector/deps/btor2tools && ./configure.sh -fPIC && make -j$(nproc); ) && \
    ( cd boolector && ./configure.sh && cd build && make -j$(nproc); ) && \
    cp boolector/build/bin/boolector /usr/local/bin/ && \
    cp boolector/build/bin/btor* /usr/local/bin/ && \
    cp boolector/deps/btor2tools/bin/btorsim /usr/local/bin/ && \
    cd /home/symbiyosys && \
    wget https://downloads.bvsrc.org/super_prove/super_prove-hwmcc17_final-2-d7b71160dddb-Ubuntu_14.04-Release.tar.gz && \
    tar xzf super_prove-hwmcc17_final-2-d7b71160dddb-Ubuntu_14.04-Release.tar.gz -C /usr/local/ && \
    echo '#!/bin/bash' >> /usr/local/bin/suprove && \
    echo 'tool=super_prove; if [ "$1" != "${1#+}" ]; then tool="${1#+}"; shift; fi' >> /usr/local/bin/suprove && \
    echo 'exec /usr/local/super_prove/bin/${tool}.sh "$@"' >> /usr/local/bin/suprove && \
    chmod +x /usr/local/bin/suprove && \
    rm -rf yosys SymbiYosys z3 yices2 extavy boolector super_prove*

RUN apt-get purge -y \
    build-essential \
    clang \
    bison \
    flex \
    libreadline-dev \
    gawk \
    libffi-dev \
    git \
    mercurial \
    graphviz \
    xdot \
    pkg-config \
    libftdi-dev \
    gperf \
    libboost-program-options-dev \
    autoconf \
    libgmp-dev \
    cmake \
    wget && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y


USER symbiyosys
WORKDIR /home/symbiyosys

RUN mkdir work
VOLUME /home/symbiyosys/work
