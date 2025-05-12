# AKS

## How can we check if the internal load balancer was created in the subnet that was chosen by the annotation `service.beta.kubernetes.io/azure-load-balancer-internal: "true"` (IPv4)

```
az network vnet subnet show --resource-group MC_byocni_amit_eastus --vnet-name aks-vnet-17718742 --name app-testing

{
  "addressPrefix": "10.228.0.0/28",
  "delegations": [],
  "etag": "W/\\"######################################\\"",
  "id": "/subscriptions/######################################/resourceGroups/MC_byocni_amit_eastus/providers/Microsoft.Network/virtualNetworks/aks-vnet-17718742/subnets/app-testing",
  "ipConfigurations": [
    {
      "id": "/subscriptions/######################################/resourceGroups/MC_BYOCNI_AMIT_EASTUS/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A7FF28CD359364E1984189FEC79574E2-APP-TESTING",
      "resourceGroup": "MC_BYOCNI_AMIT_EASTUS"
    }
  ],
  "name": "app-testing",
  "networkSecurityGroup": {
    "id": "/subscriptions/######################################/resourceGroups/mc_byocni_amit_eastus/providers/Microsoft.Network/networkSecurityGroups/aks-agentpool-17718742-nsg",
    "resourceGroup": "mc_byocni_amit_eastus"
  },
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "MC_byocni_amit_eastus",
  "routeTable": {
    "id": "/subscriptions/######################################/resourceGroups/MC_byocni_amit_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-17718742-routetable",
    "resourceGroup": "MC_byocni_amit_eastus"
  },
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```

## How can we check if the internal load balancer was created in the subnet that was chosen by the annotation `service.beta.kubernetes.io/azure-load-balancer-internal: "true"` (Dual Stack)

```
az network vnet subnet show --resource-group MC_byocnids_byocnids_southindia --vnet-name aks-vnet-14676014 --name dsapp-testing
{
  "addressPrefixes": [
    "10.225.0.0/24",
    "fd87:ef94:e938:40b4::/64"
  ],
  "defaultOutboundAccess": false,
  "delegations": [],
  "etag": "W/\\"######################################\\"",
  "id": "/subscriptions/######################################/resourceGroups/MC_byocnids_byocnids_southindia/providers/Microsoft.Network/virtualNetworks/aks-vnet-14676014/subnets/dsapp-testing",
  "ipConfigurations": [
    {
      "id": "/subscriptions/######################################/resourceGroups/MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A3166A873FF6A4EEC8FC65D5E317665D-DSAPP-TESTING",
      "resourceGroup": "MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA"
    },
    {
      "id": "/subscriptions/######################################/resourceGroups/MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A3166A873FF6A4EEC8FC65D5E317665D-DSAPP-TESTING-IPV6",
      "resourceGroup": "MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA"
    }
  ],
  "name": "dsapp-testing",
  "networkSecurityGroup": {
    "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/networkSecurityGroups/aks-agentpool-14676014-nsg",
    "resourceGroup": "mc_byocnids_byocnids_southindia"
  },
  "privateEndpointNetworkPolicies": "Disabled",
  "privateLinkServiceNetworkPolicies": "Enabled",
  "provisioningState": "Succeeded",
  "resourceGroup": "MC_byocnids_byocnids_southindia",
  "routeTable": {
    "id": "/subscriptions/######################################/resourceGroups/MC_byocnids_byocnids_southindia/providers/Microsoft.Network/routeTables/aks-agentpool-14676014-routetable",
    "resourceGroup": "MC_byocnids_byocnids_southindia"
  },
  "type": "Microsoft.Network/virtualNetworks/subnets"
}
```
## How to check if the load balancer that was created internally is attached in the respective subnet or other way around how to check for a connected device in an Azure subnet? (IPv4)

```
az network vnet subnet show -g MC_byocni_amit_eastus  -n app-testing --vnet-name aks-vnet-17718742 -o json| jq ".ipConfigurations[].id"

"/subscriptions/######################################/resourceGroups/MC_BYOCNI_AMIT_EASTUS/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A7FF28CD359364E1984189FEC79574E2-APP-TESTING"
```
## How to check if the load balancer that was created internally is attached in the respective subnet or other way around how to check for a connected device in an Azure subnet? (Dual Stack)

```
#az network vnet subnet show -g MC_byocnids_byocnids_southindia  -n dsapp-testing --vnet-name aks-vnet-14676014 -o json| jq ".ipConfigurations[].id"
"/subscriptions/######################################/resourceGroups/MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A3166A873FF6A4EEC8FC65D5E317665D-DSAPP-TESTING"
"/subscriptions/######################################/resourceGroups/MC_BYOCNIDS_BYOCNIDS_SOUTHINDIA/providers/Microsoft.Network/loadBalancers/KUBERNETES-INTERNAL/frontendIPConfigurations/A3166A873FF6A4EEC8FC65D5E317665D-DSAPP-TESTING-IPV6"
```

## How to check the available IPs in the subnet chosen for the internal load balancer? 
- This is available only for IPv4 and not Dual Stack subnets.

```
az network vnet subnet list-available-ips --resource-group MC_byocni_amit_eastus --vnet-name aks-vnet-17718742 --name app-testing
[
  "10.228.0.5",
  "10.228.0.6",
  "10.228.0.7",
  "10.228.0.8",
  "10.228.0.9"
]
```

## How to list the frontend IP for the load balancer (IPv4)

```
az network lb frontend-ip list --lb-name kubernetes-internal --resource-group MC_byocni_amit_eastus
[
  {
    "etag": "W/\\"######################################\\"",
    "id": "/subscriptions/######################################/resourceGroups/mc_byocni_amit_eastus/providers/Microsoft.Network/loadBalancers/kubernetes-internal/frontendIPConfigurations/a7ff28cd359364e1984189fec79574e2-app-testing",
    "loadBalancingRules": [
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocni_amit_eastus/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/a7ff28cd359364e1984189fec79574e2-app-testing-TCP-80",
        "resourceGroup": "mc_byocni_amit_eastus"
      },
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocni_amit_eastus/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/a7ff28cd359364e1984189fec79574e2-app-testing-TCP-443",
        "resourceGroup": "mc_byocni_amit_eastus"
      }
    ],
    "name": "a7ff28cd359364e1984189fec79574e2-app-testing",
    "privateIPAddress": "10.228.0.4",
    "privateIPAddressVersion": "IPv4",
    "privateIPAllocationMethod": "Dynamic",
    "provisioningState": "Succeeded",
    "resourceGroup": "mc_byocni_amit_eastus",
    "subnet": {
      "id": "/subscriptions/######################################/resourceGroups/MC_byocni_amit_eastus/providers/Microsoft.Network/virtualNetworks/aks-vnet-17718742/subnets/app-testing",
      "resourceGroup": "MC_byocni_amit_eastus"
    },
    "type": "Microsoft.Network/loadBalancers/frontendIPConfigurations",
    "zones": [
      "3",
      "1",
      "2"
    ]
  }
]
```
## How to list the frontend IP for the load balancer (Dual Stack)

```
az network lb frontend-ip list --lb-name kubernetes-internal --resource-group MC_byocnids_byocnids_southindia

[
  {
    "etag": "W/\\"######################################\\"",
    "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/frontendIPConfigurations/ae515bd7e7ee24829b9064c919b9a678",
    "loadBalancingRules": [
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/ae515bd7e7ee24829b9064c919b9a678-TCP-80",
        "resourceGroup": "mc_byocnids_byocnids_southindia"
      },
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/ae515bd7e7ee24829b9064c919b9a678-TCP-443",
        "resourceGroup": "mc_byocnids_byocnids_southindia"
      }
    ],
    "name": "######################################",
    "privateIPAddress": "10.224.0.7",
    "privateIPAddressVersion": "IPv4",
    "privateIPAllocationMethod": "Dynamic",
    "provisioningState": "Succeeded",
    "resourceGroup": "mc_byocnids_byocnids_southindia",
    "subnet": {
      "id": "/subscriptions/######################################/resourceGroups/MC_byocnids_byocnids_southindia/providers/Microsoft.Network/virtualNetworks/aks-vnet-14676014/subnets/aks-subnet",
      "resourceGroup": "MC_byocnids_byocnids_southindia"
    },
    "type": "Microsoft.Network/loadBalancers/frontendIPConfigurations"
  },
  {
    "etag": "W/\\"######################################b\\"",
    "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/frontendIPConfigurations/ae515bd7e7ee24829b9064c919b9a678-IPv6",
    "loadBalancingRules": [
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/ae515bd7e7ee24829b9064c919b9a678-TCP-80-IPv6",
        "resourceGroup": "mc_byocnids_byocnids_southindia"
      },
      {
        "id": "/subscriptions/######################################/resourceGroups/mc_byocnids_byocnids_southindia/providers/Microsoft.Network/loadBalancers/kubernetes-internal/loadBalancingRules/ae515bd7e7ee24829b9064c919b9a678-TCP-443-IPv6",
        "resourceGroup": "mc_byocnids_byocnids_southindia"
      }
    ],
    "name": "ae515bd7e7ee24829b9064c919b9a678-IPv6",
    "privateIPAddress": "fd87:ef94:e938:40b5::7",
    "privateIPAddressVersion": "IPv6",
    "privateIPAllocationMethod": "Dynamic",
    "provisioningState": "Succeeded",
    "resourceGroup": "mc_byocnids_byocnids_southindia",
    "subnet": {
      "id": "/subscriptions/######################################/resourceGroups/MC_byocnids_byocnids_southindia/providers/Microsoft.Network/virtualNetworks/aks-vnet-14676014/subnets/aks-subnet",
      "resourceGroup": "MC_byocnids_byocnids_southindia"
    },
    "type": "Microsoft.Network/loadBalancers/frontendIPConfigurations"
  }
]
```