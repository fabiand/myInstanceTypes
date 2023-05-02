%.env.yaml: envs/%/
	kubectl kustomize $< > $@

diff: staging.env.yaml production.env.yaml
	diff --color -u $^
