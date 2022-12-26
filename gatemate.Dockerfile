FROM hdlc/ghdl:yosys as gatemate

COPY packages/gatemate-toolchain.tar.gz /root/
RUN cd /root && \
    tar xf gatemate-toolchain.tar.gz -C /opt/ && \
    rm gatemate-toolchain.tar.gz

## Enhance path variable
ENV PATH "/opt/cc-toolchain-linux/bin/p_r:$PATH"
