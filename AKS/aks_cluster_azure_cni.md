# AKS cluster running Azure CNI

- Create a Resource Group
```
#clusterName="azurecnitocilium"
#resourceGroup="azurecnitocilium"
#vnet="azurecnitocilium"
#location="canadacentral"

#az group create --name $resourceGroup --location $location
```

- Create a virtual network with a subnet for nodes and retrieve the subnet ID.
```
@az network vnet create -g $resourceGroup --location $location --name $clusterName --address-prefixes 10.0.0.0/8 -o none

#az network vnet subnet create -g $resourceGroup --vnet-name $vnet --name $clusterName --address-prefixes 10.240.0.0/16 -o none 

#subnetid=$(az network vnet subnet show --resource-group $resourceGroup --vnet-name $vnet --name %clusterName --query id -o tsv)
```
- Create an AKS cluster, and make sure to use the argument --network-plugin as `azure`.
```
#az aks create -n $clusterName -g $resourceGroup -l $location --network-plugin azure --vnet-subnet-id $subnetid
```