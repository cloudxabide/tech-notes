# How to create an AKS cluster with Isovalent Enterprise for Cilium in BYOCNI mode.

## AKS Resource Group Creation
- Create a Resource Group
```
#az group create --name byocni --location westus
```
- Create an AKS cluster. Make sure to use the argument `--network-plugin` and set it to `none` and os-sku as `AzureLinux`
```
#az aks create -l westus -g byocnialinux -n byocnialinux --network-plugin none --os-sku AzureLinux 
```
- Install Isovalent Enterprise for Cilium
- Add an additional nodepool with OS-type as AzureLinux
```
az aks nodepool add --resource-group byocnialinux --cluster-name byocnialinux --name byocnialinux --node-count 2 --os-sku AzureLinux --mode System
```