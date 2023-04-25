SRCS=$(shell find site-*/ -type f)

all: site-dev.yaml site-prod.yaml

site-%.yaml: $(SRCS)
	kubectl kustomize site-$* | tee $@
