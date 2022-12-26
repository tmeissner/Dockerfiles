.PHONY: symbiyosys ghdl-formal riscv-gcc gatemate all NOCACHE clean copy

# Support for make environment variable NOCACHE
ifeq (NOCACHE,$(lastword $(MAKECMDGOALS)))
    OPTIONS := --no-cache
    $(info INFO: build without cache)
    $(eval $(lastword$(MAKECMDGOALS)):dummy;@:)
endif

NOCACHE:
	@#


ifndef TAG
    TAG := latest
    $(info INFO: Using predefined tag 'latest')
else
    $(info INFO: Using user given tag '${TAG}')
endif


all: symbiyosys ghdl-formal riscv-gcc gatemate

copy: copy-ghdl copy-riscv
copy-ghdl: ghdl-formal_${TAG}.tar.gz
copy-riscv: riscv-gcc_${TAG}.tar.gz


packages/gatemate-toolchain.tar.gz:
	curl https://colognechip.com/downloads/cc-toolchain-linux.tar.gz --output $@

gatemate: packages/gatemate-toolchain.tar.gz

.SECONDEXPANSION:
symbiyosys ghdl-formal riscv-gcc gatemate: $$@.Dockerfile
	docker build ${OPTIONS} -t $@:${TAG} -f $@.Dockerfile .


%_${TAG}.tar.gz:
	mkdir -p artefacts
	docker run --rm -dit --name=$*-dummy $*:${TAG} > /dev/null
	docker cp $*-dummy:/opt/. artefacts
	docker rm -f $*-dummy > /dev/null
	tar -C artefacts -czf $@ .
	shasum --algorithm 256 --UNIVERSAL $@ > $@.sha256


clean:
	rm -rf artefacts
	rm -f *.tar.*
	rm -f packages/gatemate-toolchain.tar.gz
