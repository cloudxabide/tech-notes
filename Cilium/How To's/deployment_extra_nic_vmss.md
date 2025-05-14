# How to add extra NIC's in AKS VMSS?

```
az vmss update --resource-group MC_byocni_byocni_canadacentral --name aks-egressgw-27814974-vmss  --add virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations '{"name": "config-2", "primary": false, "privateIpAddressVersion": "IPv4", "publicIpAddressConfiguration": null, "subnet": {"id": "/subscriptions/####################################/resourceGroups/byocni/providers/Microsoft.Network/virtualNetworks/byocni-vnet/subnets/egressgw-subnet", "resourceGroup": "MC_byocni_byocni_canadacentral"}}'
```