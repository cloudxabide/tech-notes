# How do you find the kAPI endpoints?

- This is a very important and pertinent question that keeps coming up and its solution is even more simpler :) 
```
kubectl cluster-info
```

```
Kubernetes control plane is running at https://################################.gr7.ap-northeast-2.eks.amazonaws.com
CoreDNS is running at https://################################.gr7.ap-northeast-2.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```