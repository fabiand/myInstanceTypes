# Overview

Kustomization of https://github.com/fabiand/instanceTypes/

This example does two things:

1. Use kustomize to create custom variants
2. Use Argo CD application to deploy these files to a cluster

This repository is very simple. There is no magic outside of
this repository besides Argo CD and Kustomize.

## Kustomize

[dev/kustomization.yaml](dev/kustomization.yaml) shows what
kind of modifications are done to the
[stock instanceTypes](https://github.com/fabiand/instanceTypes/).

## Application

[app.yaml](app.yaml) defines how Argo CD should consume
this repo, and sync it to the cluster.
Argo CD has built-in support for kustomize, therefore nothing else
is needed.

# Local build

Locally the custom instanceTypes can be produced by running:

```console
$ kubectl kustomize
```

# Deploy to cluster with Argo on OpenShift

> **Note**
> The yaml below assumes the namespace `fabiand`
> Adjust the yaml if you want to deploy the custom ITs elsewhere

The file [app.yaml](app.yaml) is an Argo Application
definition. Submitting this file to an Argo enabled cluster will
automate the whole deplpoyment.

## 1. Install OpenShift GitOps Operator and 

1. Install OpenShift GitOps using the regular OperatorHub workflow
2. Enable Argo in a namespace by creating an `ArgoCD` object
   (Use the Operator UI to do this)

## 2. Deploy the `dev instanceTypes` "App"

```console
# Deploy the small app:
$ oc apply -n fabiand -f app.yaml
application.argoproj.io/dev-instancetypes-app created
```

That's it. Argo CD will pick up the new app, and start deploying it
immediately.

## 3. Verify deployment of custom instanceTypes

Within seconds, argo should have reconciled the app.
This means the repo was cloned, kustomize applied, and resulting
artifacts deployed to the cluster:

```console
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

## 4. Optional: View Argo CD dashboard

Optionally you can log into the Argo CD dashbaord in oreder to
check what's going on:

```console
# Get the Argo admin password:
$ oc get -n fabiand secret argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d
Tc7E9v1neFp8BAOZG…

# Get the Argo dashboard path with:
$ oc get -n fabiand argocd argocd -o jsonpath="{.status.host}"
argocd-server-fabiand.apps.example.com
```

Now log into the Argo CD dashboard using `admin` and the password
from the last step.

# References

Relevant links
- https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/index.html
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- https://github.com/kubernetes-sigs/kustomize
