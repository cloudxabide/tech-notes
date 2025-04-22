# Prefix Allocation for an AKS cluster
Read more about Prefix Allocation in [Prefix Delegation in AKS](https://medium.com/@amitmavgupta/cilium-fixed-ip-allocation-vs-prefix-delegation-in-aks-873a6700a4ba)

- VNet Mode

```
kubectl get nnc -n kube-system aks-azurecilium-38229929-vmss000000 -o yaml
apiVersion: acn.azure.com/v1alpha
kind: NodeNetworkConfig
metadata:
  creationTimestamp: "2023-11-17T10:57:13Z"
  finalizers:
  - finalizers.acn.azure.com/dnc-operations
  generation: 38
  labels:
    kubernetes.azure.com/podnetwork-delegationguid: b2ed5d28-deb3-4e07-8d7c-3b93a870e51f
    kubernetes.azure.com/podnetwork-subnet: azurecilium-subnet-pods
    kubernetes.azure.com/podnetwork-type: vnet
    managed: "true"
    owner: aks-azurecilium-38229929-vmss000000
  name: aks-azurecilium-38229929-vmss000000
  namespace: kube-system
  ownerReferences:
  - apiVersion: v1
    blockOwnerDeletion: true
    controller: true
    kind: Node
    name: aks-azurecilium-38229929-vmss000000
    uid: d7b4ca7c-d628-4051-87b6-88d30126ec64
  resourceVersion: "92470"
  uid: 78827b60-c5ca-4ed3-8f8a-9f6d6f7fcbe4
spec:
  requestedIPCount: 16
status:
  assignedIPCount: 16
  networkContainers:
  - assignmentMode: dynamic
    defaultGateway: 10.241.0.1
    id: ad4514cb-59ed-4c0e-9aa9-bcd09a5052d9
    ipAssignments:
    - ip: 10.241.0.92
      name: d69a76e2-86c9-4abe-85ef-9991ac45d7f0
    - ip: 10.241.0.26
      name: 772d9641-7b47-47d8-b172-0340d9770eed
    - ip: 10.241.0.34
      name: 9539e5a0-7e79-4099-aa7c-3b18e12ead28
    - ip: 10.241.0.46
      name: ba858080-3a61-48b2-b0e9-1e89fbb23a4e
    - ip: 10.241.0.36
      name: d5fe1e9c-ce71-4a53-b92a-ff44537352fb
    - ip: 10.241.0.41
      name: 63ae5b98-df76-4a40-85e1-941fdea6c441
    - ip: 10.241.0.85
      name: 0c10b353-ece0-49f9-8f2b-c16e3de6d7ee
    - ip: 10.241.0.47
      name: 157cb440-4133-4b2c-8aae-e398380de045
    - ip: 10.241.0.81
      name: 1f4491bb-9a7d-410c-9da7-950d8f267eb5
    - ip: 10.241.0.83
      name: 435baa2a-a843-4676-875e-e86366c55f4a
    - ip: 10.241.0.22
      name: 217f471e-b91c-49d4-b3c7-106e884ef276
    - ip: 10.241.0.68
      name: 45e55d79-f8e1-4520-8a5d-065aeda159c9
    - ip: 10.241.0.27
      name: b653d000-b635-407b-95be-ce24e1405275
    - ip: 10.241.0.93
      name: 0a2edc0a-8c6a-44f0-b753-08cb903103fb
    - ip: 10.241.0.49
      name: a9666304-ad4e-4ac9-a5e4-9d48130a6f31
    - ip: 10.241.0.24
      name: f707aa3f-fdc3-4841-8ffd-2892b1a9ce7e
    nodeIP: 10.240.0.4
    primaryIP: 10.241.0.21
    resourceGroupID: azurecilium
    subcriptionID: 8dbd2563-77eb-41a1-917b-5a1344da9767
    subnetAddressSpace: 10.241.0.0/16
    subnetID: azurecilium-subnet-pods
    subnetName: azurecilium-subnet-pods
    type: vnet
    version: 26
    vnetID: azurecilium-vnet
  scaler:
    batchSize: 16
    maxIPCount: 250
    releaseThresholdPercent: 150
    requestThresholdPercent: 50
```

- Overlay Mode
```
kubectl get nnc -n kube-system aks-nodepool1-17143216-vmss000000 -o yaml
apiVersion: acn.azure.com/v1alpha
kind: NodeNetworkConfig
metadata:
  creationTimestamp: "2023-11-23T05:13:09Z"
  finalizers:
  - finalizers.acn.azure.com/dnc-operations
  generation: 1
  labels:
    kubernetes.azure.com/podnetwork-delegationguid: ""
    kubernetes.azure.com/podnetwork-subnet: ""
    kubernetes.azure.com/podnetwork-type: overlay
    managed: "true"
    owner: aks-nodepool1-17143216-vmss000000
  name: aks-nodepool1-17143216-vmss000000
  namespace: kube-system
  ownerReferences:
  - apiVersion: v1
    blockOwnerDeletion: true
    controller: true
    kind: Node
    name: aks-nodepool1-17143216-vmss000000
    uid: ca289e8b-160a-4113-b50d-898d727d2030
  resourceVersion: "752"
  uid: 60824005-8af8-4ae3-a2ca-19131a8bad64
spec:
  requestedIPCount: 0
status:
  assignedIPCount: 256
  networkContainers:
  - assignmentMode: static
    id: 5c034b2f-aef2-43fc-8a65-f9f353e3624b
    nodeIP: 10.224.0.6
    primaryIP: 192.168.1.0/24
    subnetAddressSpace: 192.168.0.0/16
    subnetName: routingdomain_0c1994ec-f208-56f6-abeb-fd3e51b272c8_overlaysubnet
    type: overlay
    version: 0
```