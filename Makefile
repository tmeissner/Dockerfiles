.PHONY: symbiyosys ghdl-formal all NOCACHE

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

.SECONDEXPANSION:
symbiyosys ghdl-formal: $$@.Dockerfile
	docker build ${OPTIONS} -t $@:${TAG} -f $@.Dockerfile .
	docker build -t $@:latest -f $@.Dockerfile .
