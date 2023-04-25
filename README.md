# Overview

Kustomization of https://github.com/fabiand/instanceTypes/

This example does two things:

1. Use kustomize to create custom variants
2. Use Argo CD application to deploy these files to a cluster

# Local build

Locally the custom instanceTypes can be produced by running:

```
$ kubectl kustomize dev
$ kubectl kustomize prod
```

# Deploy to cluster with argo on OpenShift
## 1. Install OpenShift GitOps Operator

Using the regular OperatorHub workflow.

## 2. Enable Argo in a namespace 

> **Note**
> The yaml below assumes the namespace `fabiand`
> Adjust the yaml if you want to deploy the custom ITs elsewhere

```
$ oc apply -f dev-app.yaml
```

## 3. Verify deployment of custom instanceTypes

Within seconds, argo should have reconciled the app.
This means the repo was cloned, kustomize applied, and resulting
artifacts deployed to the cluster:

```
$ oc get virtualmachineinstancetypes -n fabiand
NAME              AGE
dev-c1.2xlarge    52s
dev-c1.4xlarge    52s
dev-c1.large      52s
dev-c1.medium     52s
dev-cx1.2xlarge   52s
dev-cx1.4xlarge   52s
dev-cx1.large     52s
dev-cx1.medium    52s
…
```

# References

Relevant links
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- https://github.com/kubernetes-sigs/kustomize
