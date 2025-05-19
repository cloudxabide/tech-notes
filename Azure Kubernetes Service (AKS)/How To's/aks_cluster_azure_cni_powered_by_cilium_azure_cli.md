## What is Azure CNI Powered by Cilium?
Azure CNI Powered by Cilium combines the robust control plane of Azure CNI with the data plane of Cilium to provide high-performance networking and security.

## IPAM with Azure CNI powered by Cilium

Azure CNI Powered by Cilium can be deployed using two different methods for assigning pod IPs:

- Assign IP addresses from a virtual network (similar to existing Azure CNI with Dynamic Pod IP Assignment)
- Assign IP addresses from an overlay network (similar to Azure CNI Overlay mode)

## What’s in store for Cilium with Azure CNI powered by Cilium?

Azure CNI offers two IP addressing options for pods: the traditional configuration that assigns VNet IPs to pods and Overlay networking. The choice of which option to use for your AKS cluster is a balance between flexibility and advanced configuration needs. The following considerations help outline when each network model may be the most appropriate.

**Use Overlay networking when**:

- You would like to scale to a large number of pods, but have limited IP address space in your VNet.
- Most of the pod communication is within the cluster.
- You don't need advanced AKS features, such as virtual nodes.

**Use the traditional VNet option when**:

- You have available IP address space.
- Most of the pod communication is to resources outside of the cluster.
- Resources outside the cluster need to reach pods directly.
- You need AKS advanced features, such as virtual nodes.

## Limitations

Azure CNI powered by Cilium currently has the following limitations:

- Available only for Linux and not for Windows.
- Cilium L7 policy enforcement is disabled.
- Hubble is disabled.
- Kubernetes services with `internalTrafficPolicy=Local` aren't supported ([Cilium issue #17796](https://github.com/cilium/cilium/issues/17796)).
    - Tracked now via https://github.com/isovalent/roadmap/issues/841
- Multiple Kubernetes services can't use the same host port with different protocols (for example, TCP or UDP) ([Cilium issue #14287](https://github.com/cilium/cilium/issues/14287)).
- Network policies may be enforced on reply packets when a pod connects to itself via service cluster IP ([Cilium issue #19406](https://github.com/cilium/cilium/issues/19406)).

# How to create an AKS cluster in VNet (Dynamic IP) mode with Azure CNI powered by Cilium?

```
az group create --name cluster1 --location canadacentral

az network vnet create -g cluster1 --location canadacentral --name cluster1 --address-prefixes 192.168.16.0/22 -o none

az network vnet subnet create -g cluster1 --vnet-name cluster1 --name nodesubnet --address-prefixes 192.168.16.0/24 -o none

az network vnet subnet create -g cluster1 --vnet-name cluster1 --name podsubnet --address-prefixes 192.168.17.0/24 -o none

az aks create -n cluster1 -g cluster1 -l canadacentral \
  --max-pods 250 \
  --network-plugin azure \
  --vnet-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/nodesubnet \
  --pod-subnet-id /subscriptions/<subscription>/resourceGroups/cluster1/providers/Microsoft.Network/virtualNetworks/cluster1/subnets/podsubnet \
  --network-dataplane cilium

az aks get-credentials --resource-group cluster1 --name cluster1
```

# How to create an AKS cluster in Overlay Mode with Azure CNI powered by Cilium?

```
az group create --name azpcoverlay --location francecentral

az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --network-dataplane cilium

az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --kubernetes-version 1.29 \
  --network-dataplane cilium
```

# How to create an AKS cluster in Node Subnet Mode with Azure CNI powered by Cilium?

- Register the feature
```
az feature register --name EnableCiliumNodeSubnet --namespace Microsoft.ContainerService
az provider register -n Microsoft.ContainerService
```
- Verify that the feature is registered
```
az feature show --namespace "Microsoft.ContainerService" --name "EnableCiliumNodeSubnet"
```
- Create a Resource Group
```
az group create --name azpcnodesubnet --location canadacentral
```
- Create an AKS cluster with cilium as the eBPF dataplane.
```
az aks create --name azpcnodesubnet --resource-group azpcnodesubnet --location canadacentral --network-plugin azure --network-dataplane cilium --generate-ssh-keys
```
- Notice that each node has a different subnet. Notice that pods are getting an IP address in the same subnet and can talk directly with other pods and services.
```
kubectl get nodes -o wide
NAME                                STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-nodepool1-27049142-vmss000000   Ready    <none>   2m49s   v1.31.7   10.224.0.62   <none>        Ubuntu 22.04.5 LTS   5.15.0-1087-azure   containerd://1.7.27-1
aks-nodepool1-27049142-vmss000001   Ready    <none>   2m49s   v1.31.7   10.224.0.33   <none>        Ubuntu 22.04.5 LTS   5.15.0-1087-azure   containerd://1.7.27-1
aks-nodepool1-27049142-vmss000002   Ready    <none>   3m1s    v1.31.7   10.224.0.4    <none>        Ubuntu 22.04.5 LTS   5.15.0-1087-azure   containerd://1.7.27-1

kubectl get pods -o wide -A
NAMESPACE     NAME                                            READY   STATUS    RESTARTS       AGE     IP            NODE                                NOMINATED NODE   READINESS GATES
kube-system   azure-cns-2q6pb                                 1/1     Running   0              3m9s    10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   azure-cns-6vf24                                 1/1     Running   0              2m57s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   azure-cns-vcj99                                 1/1     Running   0              2m57s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   azure-ip-masq-agent-dvx67                       1/1     Running   0              2m57s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   azure-ip-masq-agent-kdz8h                       1/1     Running   0              2m57s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   azure-ip-masq-agent-xc987                       1/1     Running   0              3m9s    10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   cilium-7857j                                    1/1     Running   0              2m24s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   cilium-mn6gh                                    1/1     Running   0              2m24s   10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   cilium-operator-6dfc48dfd9-89ltw                1/1     Running   0              2m24s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   cilium-operator-6dfc48dfd9-knr2h                1/1     Running   0              2m24s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   cilium-wgq74                                    1/1     Running   0              2m24s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   cloud-node-manager-2zjqh                        1/1     Running   0              2m57s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   cloud-node-manager-44hq2                        1/1     Running   0              3m9s    10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   cloud-node-manager-62lg8                        1/1     Running   0              2m57s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   coredns-57d886c994-klrds                        1/1     Running   0              3m34s   10.224.0.9    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   coredns-57d886c994-rbchr                        1/1     Running   0              113s    10.224.0.42   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   coredns-autoscaler-55bcd876cc-wsnrw             1/1     Running   0              3m34s   10.224.0.6    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   csi-azuredisk-node-64bcf                        3/3     Running   0              2m57s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   csi-azuredisk-node-ckl6s                        3/3     Running   0              2m57s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-rvjch                        3/3     Running   0              3m9s    10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   csi-azurefile-node-gjnlf                        3/3     Running   0              2m57s   10.224.0.33   aks-nodepool1-27049142-vmss000001   <none>           <none>
kube-system   csi-azurefile-node-z6r95                        3/3     Running   0              3m8s    10.224.0.4    aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   csi-azurefile-node-z7qjm                        3/3     Running   0              2m57s   10.224.0.62   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   konnectivity-agent-84b5c4656f-bqmqm             1/1     Running   0              111s    10.224.0.89   aks-nodepool1-27049142-vmss000000   <none>           <none>
kube-system   konnectivity-agent-84b5c4656f-tfbsk             1/1     Running   0              3m33s   10.224.0.17   aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   konnectivity-agent-autoscaler-679b77b4f-bxnj4   1/1     Running   0              3m33s   10.224.0.12   aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   metrics-server-7d48979d75-24gkb                 2/2     Running   2 (107s ago)   3m33s   10.224.0.15   aks-nodepool1-27049142-vmss000002   <none>           <none>
kube-system   metrics-server-7d48979d75-r7pgk                 2/2     Running   2 (107s ago)   3m33s   10.224.0.23   aks-nodepool1-27049142-vmss000002   <none>           <none>
```
- How can you check the utilization of IP addresses in Node Subnet?
  - You can run an API call to see the effective utilization of IP addresses while using the Node Subnet option.
  - Every IP is being added as an alias under the VMSS.
```json
GET https://management.azure.com/subscriptions/###################################/resourceGroups/MC_azpcnodesubnet_azpcnodesubnet_canadacentral/providers/Microsoft.Network/virtualNetworks/aks-vnet-###########?api-version=2024-05-01

{
  "name": "aks-vnet-###########",
  "id": "/subscriptions/###################################/resourceGroups/MC_azpcnodesubnet_azpcnodesubnet_canadacentral/providers/Microsoft.Network/virtualNetworks/aks-vnet-###########",
  "etag": "W/\"###################################\"",
  "type": "Microsoft.Network/virtualNetworks",
  "location": "canadacentral",
  "tags": {},
  "properties": {
    "provisioningState": "Succeeded",
    "resourceGuid": "#"###########################,
    "addressSpace": {
      "addressPrefixes": [
        "10.224.0.0/12"
      ]
    },
    "privateEndpointVNetPolicies": "Disabled",
    "subnets": [
      {
        "name": "aks-subnet",
        "id": "/subscriptions/###################################/resourceGroups/MC_azpcnodesubnet_azpcnodesubnet_canadacentral/providers/Microsoft.Network/virtualNetworks/aks-vnet-###########/subnets/aks-subnet",
        "etag": "W/\"####################\"",
        "properties": {
          "provisioningState": "Succeeded",
          "addressPrefix": "10.224.0.0/16",
          "networkSecurityGroup": {
            "id": "/subscriptions/###################################/resourceGroups/MC_azpcnodesubnet_azpcnodesubnet_canadacentral/providers/Microsoft.Network/networkSecurityGroups/aks-agentpool-###########-nsg"
          },
          "ipConfigurations": [
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG1"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG10"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG11"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG12"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG13"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG14"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG15"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG16"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG17"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG18"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG19"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG2"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG20"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG21"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG22"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG23"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG24"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG25"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG26"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG27"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG28"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG29"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG3"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG4"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG5"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG6"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG7"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG8"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/0/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG9"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG1"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG10"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG11"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG12"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG13"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG14"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG15"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG16"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG17"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG18"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG19"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG2"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG20"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG21"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG22"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG23"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG24"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG25"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG26"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG27"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG28"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG29"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG3"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG4"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG5"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG6"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG7"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG8"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/1/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG9"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG1"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG10"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG11"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG12"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG13"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG14"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG15"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG16"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG17"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG18"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG19"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG2"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG20"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG21"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG22"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG23"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG24"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG25"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG26"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG27"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG28"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG29"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG3"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG4"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG5"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG6"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG7"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG8"
            },
            {
              "id": "/subscriptions/###################################/resourceGroups/MC_AZPCNODESUBNET_AZPCNODESUBNET_CANADACENTRAL/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINESCALESETS/AKS-NODEPOOL1-###########-VMSS/VIRTUALMACHINES/2/NETWORKINTERFACES/AKS-NODEPOOL1-###########-VMSS/ipConfigurations/IPCONFIG9"
            }
          ],
          "delegations": [],
          "privateEndpointNetworkPolicies": "Disabled",
          "privateLinkServiceNetworkPolicies": "Enabled"
        },
        "type": "Microsoft.Network/virtualNetworks/subnets"
      }
    ],
    "virtualNetworkPeerings": [],
    "enableDdosProtection": false
  }
}
```
