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