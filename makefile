%.overlay.yaml: overlays/%/
	kubectl kustomize $< > $@

diff: staging.overlay.yaml production.overlay.yaml
	diff --color -u $^
