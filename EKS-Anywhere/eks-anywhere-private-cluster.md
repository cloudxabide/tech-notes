# How to create a Private EKS-Anywhere cluster (Airgapped) with no outbound connectivity?

## Resources
- [EKS-A Airgapped](https://anywhere.eks.amazonaws.com/docs/getting-started/airgapped/)
- [Registry Mirror](https://anywhere.eks.amazonaws.com/docs/getting-started/optional/registrymirror/)

## Pre-Requisites
- Configure local registry mirror. The following projects must be created in your registry before importing the EKS Anywhere images:
    - bottlerocket
    - eks-anywhere
    - eks-distro
    - isovalent
    - cilium-chart
- An existing Admin machine.
    - Docker running on the Admin machine
    - At least 80GB in storage space on the Admin machine to temporarily store the EKS Anywhere images locally before importing them to your local registry. Currently, when downloading images, EKS Anywhere pulls all dependencies for all infrastructure providers and supported Kubernetes versions.
    - The download and import images commands must be run on an amd64 machine to import amd64 images to the registry mirror.

## Let's get going

- Download the EKS Anywhere artifacts that contain the list and locations of the EKS Anywhere dependencies. A compressed file `eks-anywhere-downloads.tar.gz` will be downloaded. You can use the eksctl anywhere download artifacts `--dry-run` command to see the list of artifacts it will download.

```
#eksctl anywhere download artifacts
```

- Decompress the eks-anywhere-downloads.tar.gz file using the following command. This will create an `eks-anywhere-downloads` folder.

```
#tar -xvf eks-anywhere-downloads.tar.gz
```

- Download the EKS Anywhere image dependencies to the Admin machine. This command may take several minutes (10+) to complete. To monitor the progress of the command, you can run with the `-v 6` command line argument, which will show details of the images that are being pulled. Docker must be running for the following command to succeed.

```
#eksctl anywhere download images -o images.tar
Pulling images from origin, this might take a while
Writing images to disk
Pulling images from origin, this might take a while
Writing images to disk
Saving helm chart to disk	{"chart": "public.ecr.aws/eks-anywhere/eks-anywhere-packages:0.4.5-eks-a-93"}
Saving helm chart to disk	{"chart": "public.ecr.aws/eks-anywhere/tinkerbell/stack:0.6.2-eks-a-93"}
Saving helm chart to disk	{"chart": "public.ecr.aws/eks-anywhere/tinkerbell/tinkerbell-chart:0.2.7-eks-a-93"}
Saving helm chart to disk	{"chart": "public.ecr.aws/eks-anywhere/tinkerbell/tinkerbell-crds:0.2.6-eks-a-93"}
Saving helm chart to disk	{"chart": "public.ecr.aws/isovalent/cilium:1.15.13-eksa.2"}
Packaging artifacts	{"dst": "images.tar"}
```

- Import images to the local registry mirror

- Create the cluster

```
#eksctl anywhere generate clusterconfig eksaprivate --provider docker > eksaprivate.yaml
#eksctl anywhere create cluster -f eksaprivate.yaml --bundles-override ./eks-anywhere-downloads/bundle-release.yaml
Performing setup and validations
Warning: The docker infrastructure provider is meant for local development and testing only
✅ Docker Provider setup is valid
✅ Validate OS is compatible with registry mirror configuration
✅ Validate certificate for registry mirror
✅ Validate authentication for git provider
✅ Validate cluster's eksaVersion matches EKS-A version
✅ Validate extended kubernetes version support is supported
Creating new bootstrap cluster
Provider specific pre-capi-install-setup on bootstrap cluster
Installing cluster-api providers on bootstrap cluster
Provider specific post-setup
Installing EKS-A custom components on bootstrap cluster
Installing EKS-D components
Installing EKS-A custom components (CRD and controller)
Creating new management cluster
Creating EKS-A namespace
Installing cluster-api providers on management cluster
Installing EKS-A secrets on management cluster
Moving the cluster management components from the bootstrap cluster to the management cluster
Installing EKS-A custom components on the management cluster
Installing EKS-D components
Installing EKS-A custom components (CRD and controller)
Moving cluster spec to workload cluster
Installing GitOps Toolkit on workload cluster
GitOps field not specified, bootstrap flux skipped
Writing cluster config file
Deleting bootstrap cluster
🎉 Cluster created!
--------------------------------------------------------------------------------------
The Amazon EKS Anywhere Curated Packages are only available to customers with the
Amazon EKS Anywhere Enterprise Subscription
--------------------------------------------------------------------------------------
Enabling curated packages on the cluster
Installing helm chart on cluster	{"chart": "eks-anywhere-packages", "version": "0.4.5-eks-a-93"}
```