# How to upgrade the Kubernetes version on an EKS-A cluster?

- In the basic cluster file that is created at the time of cluster creation, edit `kubernetesVersion: x` to a specific value and then upgrade the cluster using the same file.

```
#eksctl anywhere upgrade cluster -f mgmt.yaml
```