# How to find the architecture type of Kubernetes nodes?

```
kubectl get no -L kubernetes.io/arch
NAME                                                 STATUS   ROLES    AGE   VERSION                ARCH
ip-192-168-109-226.ap-northeast-2.compute.internal   Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
ip-192-168-160-133.ap-northeast-2.compute.internal   Ready    <none>   57m   v1.29.12-eks-aeac579   arm64
```