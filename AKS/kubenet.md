# What is Kubenet?
- On 31 March 2028, kubenet networking for Azure Kubernetes Service (AKS) will be retired.
AKS clusters use kubenet and create an Azure virtual network and subnet for you by default. With kubenet, nodes get an IP address from the Azure virtual network subnet. 

- Pods receive an IP address from a logically different address space to the Azure virtual network subnet of the nodes.
- Network address translation (NAT) is then configured so the pods can reach resources on the Azure virtual network.
- The source IP address of the traffic is NAT'd to the node's primary IP address.
- This approach greatly reduces the number of IP addresses you need to reserve in your network space for pods to use.

With *kubenet*, only the nodes receive an IP address in the virtual network subnet. Pods can't communicate directly with each other. 

- Instead, User Defined Routing (UDR) and IP forwarding handle connectivity between pods across nodes.
- UDRs and IP forwarding configuration is created and maintained by the AKS service by default, but you can [bring your own route table for custom route management](https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#bring-your-own-subnet-and-route-table-with-kubenet) if you want.
- You can also deploy pods behind a service that receives an assigned IP address and load balances traffic for the application.
- Azure supports a maximum of *400* routes in a UDR, so you can't have an AKS cluster larger than 400 nodes.

### **Limitations & considerations for kubenet**

- An additional hop is required in the design of kubenet, which adds minor latency to pod communication.
- Route tables and user-defined routes are required for using kubenet, which adds complexity to operations.
- Direct pod addressing isn't supported for kubenet due to kubenet design.
- Unlike Azure CNI clusters, multiple kubenet clusters can't share a subnet.
- AKS doesn't apply Network Security Groups (NSGs) to its subnet and doesn't modify any of the NSGs associated with that subnet. If you provide your subnet and add NSGs associated with that subnet, you must ensure the security rules in the NSGs allow traffic between the node and pod CIDR.
- Features **not supported on kubenet** include:
    - [Azure network policies](https://learn.microsoft.com/en-us/azure/aks/use-network-policies#create-an-aks-cluster-and-enable-network-policy)
    - [Windows node pools](https://learn.microsoft.com/en-us/azure/aks/windows-faq)
    - [Virtual nodes add-on](https://learn.microsoft.com/en-us/azure/aks/virtual-nodes#network-requirements)

## Support for Dual-Stack

You can deploy your AKS clusters in a dual-stack mode when using [kubenet](https://learn.microsoft.com/en-us/azure/aks/configure-kubenet) networking and a dual-stack Azure virtual network. 

- In this configuration, nodes receive both an IPv4 and IPv6 address from the Azure virtual network subnet.
- Pods receive both an IPv4 and IPv6 address from a logically different address space to the Azure virtual network subnet of the nodes.
- Network address translation (NAT) is then configured so that the pods can reach resources on the Azure virtual network.
- The source IP address of the traffic is NAT'd to the node's primary IP address of the same family (IPv4 to IPv4 and IPv6 to IPv6).

### **Limitations for Dual-Stack with Kubenet**

- Azure route tables have a **hard limit of 400 routes per table**.
    - Each node in a dual-stack cluster requires two routes, one for each IP address family, so **dual-stack clusters are limited to 200 nodes**.
- In Azure Linux node pools, service objects are only supported with `externalTrafficPolicy: Local`.
- Dual-stack networking is required for the Azure virtual network and the pod CIDR.
    - Single stack IPv6-only isn't supported for node or pod IP addresses. Services can be provisioned on IPv4 or IPv6.
- The following features are **not supported on dual-stack kubenet**:
    - Azure network policies
    - Calico network policies
    - NAT Gateway
    - Virtual nodes add-on
    - Windows node pools

### Sample API call for creating/updating the Routing Table

```json
{
    "authorization": {
        "action": "Microsoft.Network/routeTables/write",
        "scope": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable"
    },
    "caller": "#####################################",
    "channels": "Operation",
    "claims": {
        "aud": "https://management.core.windows.net/",
        "iss": "https://sts.windows.net/#####################################/",
        "iat": "1692158288",
        "nbf": "1692158288",
        "exp": "1692244988",
        "aio": "#####################################",
        "appid": "#####################################",
        "appidacr": "2",
        "http://schemas.microsoft.com/identity/claims/identityprovider": "https://sts.windows.net/#####################################/",
        "idtyp": "app",
        "http://schemas.microsoft.com/identity/claims/objectidentifier": "#####################################",
        "rh": "0.AVEAddpcYt1iDkelVHMTh3_wPEZIf3kAutdPukPawfj2MBNRAAA.",
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier": "#####################################",
        "http://schemas.microsoft.com/identity/claims/tenantid": "#####################################",
        "uti": "cRZ8-NDqNECeq2PmIKW8Ag",
        "ver": "1.0",
        "xms_mirid": "/subscriptions/#####################################/resourcegroups/nwpluginkubenet/providers/Microsoft.ContainerService/managedClusters/nwpluginkubenet",
        "xms_tcdt": "1589910443"
    },
    "correlationId": "#####################################",
    "description": "",
    "eventDataId": "#####################################",
    "eventName": {
        "value": "BeginRequest",
        "localizedValue": "Begin request"
    },
    "category": {
        "value": "Administrative",
        "localizedValue": "Administrative"
    },
    "eventTimestamp": "2023-08-16T04:04:07.5557146Z",
    "id": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable/events/#####################################/ticks/#####################################",
    "level": "Informational",
    "operationId": "#####################################",
    "operationName": {
        "value": "Microsoft.Network/routeTables/write",
        "localizedValue": "Create or Update Route Table"
    },
    "resourceGroupName": "mc_nwpluginkubenet_nwpluginkubenet_eastus",
    "resourceProviderName": {
        "value": "Microsoft.Network",
        "localizedValue": "Microsoft.Network"
    },
    "resourceType": {
        "value": "Microsoft.Network/routeTables",
        "localizedValue": "Microsoft.Network/routeTables"
    },
    "resourceId": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable",
    "status": {
        "value": "Started",
        "localizedValue": "Started"
    },
    "subStatus": {
        "value": "",
        "localizedValue": ""
    },
    "submissionTimestamp": "2023-08-16T04:07:23Z",
    "subscriptionId": "#####################################",
    "tenantId": "#####################################",
    "properties": {
        "requestbody": "{\"id\":\"/subscriptions/#####################################/resourceGroups/MC_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable\",\"location\":\"eastus\",\"properties\":{\"disableBgpRoutePropagation\":false,\"routes\":[{\"name\":\"aks-nodepool1-12355964-vmss000001____102441024\",\"properties\":{\"addressPrefix\":\"10.244.1.0/24\",\"nextHopIpAddress\":\"192.168.1.5\",\"nextHopType\":\"VirtualAppliance\"}},{\"name\":\"aks-nodepool1-12355964-vmss000000____102440024\",\"properties\":{\"addressPrefix\":\"10.244.0.0/24\",\"nextHopIpAddress\":\"192.168.1.4\",\"nextHopType\":\"VirtualAppliance\"}}]},\"tags\":{}}",
        "eventCategory": "Administrative",
        "entity": "/subscriptions/#####################################/resourceGroups/mc_nwpluginkubenet_nwpluginkubenet_eastus/providers/Microsoft.Network/routeTables/aks-agentpool-48350840-routetable",
        "message": "Microsoft.Network/routeTables/write",
        "hierarchy": "625cda75-62dd-470e-a554-7313877ff03c/cilium/#####################################"
    },
    "relatedEvents": []
}
```