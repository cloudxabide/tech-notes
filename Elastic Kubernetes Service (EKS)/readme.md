# Creating EKS Cluster via eksctl
- Use the manifests in this directory to create EKS clusters via `eksctl`
```
eksctl create cluster -f <filename.yaml>
```
- Install Cilium in ENI mode for manifests that are catering to Cilium as the CNI.
```
helm install cilium cilium/cilium --version 1.17.4 \
  --namespace kube-system \
  --set eni.enabled=true \
  --set ipam.mode=eni \
  --set egressMasqueradeInterfaces=eth+ \
  --set routingMode=native
```
