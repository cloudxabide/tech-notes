# Find/List an EKS-A cluster

```
kubectl get clusters <cluster-name> -o yaml
```
# Delete an EKS-A cluster

```
#eksctl anywhere delete cluster mgmt -f mgmt.yaml
```

```
Performing provider setup and validations
Creating new bootstrap cluster
Provider specific pre-capi-install-setup on bootstrap cluster
Installing cluster-api providers on bootstrap cluster
Moving cluster management from workload cluster to bootstrap
Installing EKS-A custom components on bootstrap cluster
Installing EKS-D components
Installing EKS-A custom components (CRD and controller)
Deleting management cluster
Clean up Git Repo
GitOps field not specified, clean up git repo skipped
Deleting bootstrap cluster
🎉 Cluster deleted!
```

