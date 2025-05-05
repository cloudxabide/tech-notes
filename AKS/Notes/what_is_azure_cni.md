# What is Azure CNI?

With Azure Container Networking Interface (CNI), every pod gets an IP address from the subnet and can be accessed directly. 

- These IP addresses must be planned and unique across your network space.
- Each node has a configuration parameter for the maximum number of pods it supports.
- The equivalent number of IP addresses per node is then reserved up front for that node.
- This approach requires more planning and often leads to IP address exhaustion or the need to rebuild clusters in a larger subnet as your application demands grow.
- You can configure the maximum pods deployable to a node at cluster creation time or when creating new node pools. If you don't specify `maxPods` when creating new node pools, you receive a default value of 300 for Azure CNI.

## What’s in store for Cilium with Azure CNI?

- "Azure CNI" is the historical and current default option when you create AKS clusters. For installing Cilium in such a cluster, it was possible to use either:
    - Azure IPAM integration (now dubbed "Legacy Azure IPAM"). Under the hood, this removes Azure CNI and replaces it with Cilium as the only CNI on the nodes. It should be avoided because new nodes will have pods scheduled on them before Cilium comes in to remove Azure CNI and replace it. The only advantage of Azure IPAM is that it has deeper integration capabilities with the Azure API, and a couple of advanced Cilium users have built tooling around it.