FROM hdlc/ghdl:yosys as gatemate

COPY packages/gatemate-toolchain.tar.gz /root/
RUN cd /root && \
    tar xf gatemate-toolchain.tar.gz -C /opt/ && \
    rm gatemate-toolchain.tar.gz

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    iverilog && \
    apt-get -y upgrade && apt-get autoclean && apt-get clean && apt-get -y autoremove && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

## Enhance path variable
ENV PATH "/opt/cc-toolchain-linux/bin/p_r:$PATH"
