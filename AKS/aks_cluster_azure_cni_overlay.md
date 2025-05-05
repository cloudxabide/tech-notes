# AKS cluster running Azure CNI Overlay

- Create a Resource Group

```
#clusterName="overlaytocilium"
#resourceGroup="overlaytocilium"
#vnet="overlaytocilium"
#location="westcentralus"

#az group create --name $resourceGroup --location $location
```
- Create an AKS cluster with Azure CNI Overlay with --network-plugin mode as `overlay`.
```
#az aks create -n $clusterName -g $resourceGroup --location $location --network-plugin azure --network-plugin-mode overlay --pod-cidr 192.168.0.0/16
```