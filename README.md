# Dockerfiles

A collection of Dockerfiles for easy use of various free & open-source tools. Have fun!

## symbiyosys.Dockerfile

**Included tools:**

* Yosys
* SymbiYosys
* Z3
* Yices2
* CVC4
* Boolector
* Bitwuzla
* Super Prove

## ghdl-formal.Dockerfile

Based on *symbiyosys.Dockerfile*

**Included tools:**

* All of *symbiyosys.Dockerfile*
* GHDL
* ghdl-yosys-plugin

**A similar image is the [`hdlc/formal`](https://hub.docker.com/r/hdlc/formal/tags) docker image and its variants provided by the [hdl containers project](https://hdl.github.io/containers/). I recommend it because it is provided through docker hub. No need to build images by yourself.**

## riscv-gcc.Dockerfile

Risc-V toolchain to develop programs for [NEORV32](https://github.com/stnolting/neorv32) CPU. Built for instruction set `rv32i` and ABI `ilp32`.

**Included tools:**

* gcc
* gdb
* ...


## Further Ressources

* [Yosys](https://github.com/YosysHQ/yosys)
* [SymbiYosys](https://github.com/YosysHQ/SymbiYosys)
* [GHDL](https://github.com/ghdl/ghdl)
* [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
* [Z3](https://github.com/Z3Prover/z3)
* [Yices 2](https://yices.csl.sri.com/)
* [CVC4](https://cvc4.github.io/)
* [Boolector](https://boolector.github.io/)
* [Bitwuzla](https://bitwuzla.github.io/)
* [Super Prove](https://github.com/berkeley-abc/super_prove)
* [RISC-V Toolchain](https://github.com/riscv/riscv-gcc)
