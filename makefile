.PHONY: site-dev.yaml site-prod.yaml

all: site-dev.yaml site-prod.yaml

%.yaml:
	kubectl kustomize $* | tee $@
