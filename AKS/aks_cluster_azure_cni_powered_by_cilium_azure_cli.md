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

# How to create an AKS cluster in Overlay Mode with Azure CNI powered by Cilium?

```
#az group create --name azpcoverlay --location francecentral

#az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --network-dataplane cilium

#az aks create -n azpcoverlay -g azpcoverlay -l francecentral \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --pod-cidr 192.168.0.0/16 \
  --kubernetes-version 1.29 \
  --network-dataplane cilium
```
