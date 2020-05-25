.PHONY: symbiyosys ghdl-formal all NOCACHE clean copy

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


all: symbiyosys ghdl-formal

copy: ghdl-formal_${TAG}.tar.gz


.SECONDEXPANSION:
symbiyosys ghdl-formal: $$@.Dockerfile
	docker build ${OPTIONS} -t $@:${TAG} -f $@.Dockerfile .


ghdl-formal_${TAG}.tar.gz:
	mkdir -p artefacts
	docker run --rm -dit --name=ghdl-dummy ghdl-formal:${TAG} > /dev/null
	docker cp ghdl-dummy:/opt/. artefacts
	docker rm -f ghdl-dummy > /dev/null
	tar -C artefacts -czf ghdl-formal_${TAG}.tar.gz .


clean:
	rm -rf artefacts
	rm -f ghdl-formal_*.tar.gz
