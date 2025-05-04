# How to create an AKS cluster in VNet (Dynamic IP mode) with Azure CNI powered by Cilium?

```
#az group create --name cluster1 --location canadacentral

#az network vnet create -g cluster1 --location canadacentral --name cluster1 --address-prefixes 192.168.16.0/22 -o none

#az network vnet subnet create -g cluster1 --vnet-name cluster1 --name nodesubnet --address-prefixes 192.168.16.0/24 -o none

#az network vnet subnet create -g cluster1 --vnet-name cluster1 --name podsubnet --address-prefixes 192.168.17.0/24 -o none

#az aks create -n cluster1 -g cluster1 -l canadacentral \
  --max-pods 250 \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/nodesubnet \
  --pod-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/podsubnet \
  --network-dataplane cilium

#az aks get-credentials --resource-group cluster1 --name cluster1
```