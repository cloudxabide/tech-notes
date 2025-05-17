# Network Node Config with delegated-IPAM

[Azure Delegated Ipam allocator](https://docs.cilium.io/en/stable/network/concepts/ipam/azure-delegated-ipam/) builds on top of CRD-backed allocator. AKS control plane creates NodeNetworkConfig custom resource on each node matching node name.

```
kubectl get nnc -A -ojson
```

```json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "acn.azure.com/v1alpha",
            "kind": "NodeNetworkConfig",
            "metadata": {
                "creationTimestamp": "2024-03-12T08:05:40Z",
                "finalizers": [
                    "finalizers.acn.azure.com/dnc-operations"
                ],
                "generation": 1,
                "labels": {
                    "kubernetes.azure.com/podnetwork-delegationguid": "",
                    "kubernetes.azure.com/podnetwork-subnet": "",
                    "kubernetes.azure.com/podnetwork-type": "overlay",
                    "managed": "true",
                    "owner": "aks-nodepool1-64579201-vmss000000"
                },
                "name": "aks-nodepool1-64579201-vmss000000",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "Node",
                        "name": "aks-nodepool1-64579201-vmss000000",
                        "uid": "5ec91f26-a4f9-415f-b529-50744c5c5068"
                    }
                ],
                "resourceVersion": "1003",
                "uid": "8456f363-53f0-4335-adc0-c1ba3681e700"
            },
            "spec": {
                "requestedIPCount": 0
            },
            "status": {
                "assignedIPCount": 512,
                "networkContainers": [
                    {
                        "assignmentMode": "static",
                        "id": "2c2ef066-9878-4ed5-a881-55c6b5fcdcaa",
                        "nodeIP": "10.224.0.4",
                        "primaryIP": "fdcb:b00:7545:bf38::100/120",
                        "subnetAddressSpace": "fdcb:b00:7545:bf38::/64",
                        "subnetName": "routingdomain_4c4572f6-230e-55b4-a532-0694a0a47798_overlaysubnet_ipv6",
                        "type": "overlay",
                        "version": 0
                    },
                    {
                        "assignmentMode": "static",
                        "id": "46be4391-107b-4fc3-b67b-01d1f1903378",
                        "nodeIP": "10.224.0.4",
                        "primaryIP": "10.244.1.0/24",
                        "subnetAddressSpace": "10.244.0.0/16",
                        "subnetName": "routingdomain_b12b2d74-7eab-5ab9-9f68-1839bb52a384_overlaysubnet",
                        "type": "overlay",
                        "version": 0
                    }
                ]
            }
        },
        {
            "apiVersion": "acn.azure.com/v1alpha",
            "kind": "NodeNetworkConfig",
            "metadata": {
                "creationTimestamp": "2024-03-12T08:05:29Z",
                "finalizers": [
                    "finalizers.acn.azure.com/dnc-operations"
                ],
                "generation": 1,
                "labels": {
                    "kubernetes.azure.com/podnetwork-delegationguid": "",
                    "kubernetes.azure.com/podnetwork-subnet": "",
                    "kubernetes.azure.com/podnetwork-type": "overlay",
                    "managed": "true",
                    "owner": "aks-nodepool1-64579201-vmss000001"
                },
                "name": "aks-nodepool1-64579201-vmss000001",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "Node",
                        "name": "aks-nodepool1-64579201-vmss000001",
                        "uid": "e8d14a19-13e4-4090-b403-49d5accb862e"
                    }
                ],
                "resourceVersion": "824",
                "uid": "89f0527c-c261-4bd6-a0ec-b98c29dbdf20"
            },
            "spec": {
                "requestedIPCount": 0
            },
            "status": {
                "assignedIPCount": 512,
                "networkContainers": [
                    {
                        "assignmentMode": "static",
                        "id": "3121e039-f237-463c-bce2-3138dd95a6f6",
                        "nodeIP": "10.224.0.5",
                        "primaryIP": "fdcb:b00:7545:bf38::/120",
                        "subnetAddressSpace": "fdcb:b00:7545:bf38::/64",
                        "subnetName": "routingdomain_4c4572f6-230e-55b4-a532-0694a0a47798_overlaysubnet_ipv6",
                        "type": "overlay",
                        "version": 0
                    },
                    {
                        "assignmentMode": "static",
                        "id": "b3581e4c-f8f8-41ec-a193-dfa5e7bc62bb",
                        "nodeIP": "10.224.0.5",
                        "primaryIP": "10.244.0.0/24",
                        "subnetAddressSpace": "10.244.0.0/16",
                        "subnetName": "routingdomain_b12b2d74-7eab-5ab9-9f68-1839bb52a384_overlaysubnet",
                        "type": "overlay",
                        "version": 0
                    }
                ]
            }
        },
        {
            "apiVersion": "acn.azure.com/v1alpha",
            "kind": "NodeNetworkConfig",
            "metadata": {
                "creationTimestamp": "2024-03-12T08:05:55Z",
                "finalizers": [
                    "finalizers.acn.azure.com/dnc-operations"
                ],
                "generation": 1,
                "labels": {
                    "kubernetes.azure.com/podnetwork-delegationguid": "",
                    "kubernetes.azure.com/podnetwork-subnet": "",
                    "kubernetes.azure.com/podnetwork-type": "overlay",
                    "managed": "true",
                    "owner": "aks-nodepool1-64579201-vmss000002"
                },
                "name": "aks-nodepool1-64579201-vmss000002",
                "namespace": "kube-system",
                "ownerReferences": [
                    {
                        "apiVersion": "v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "Node",
                        "name": "aks-nodepool1-64579201-vmss000002",
                        "uid": "e2f14c60-fd55-478f-94cd-4ce6133b50ab"
                    }
                ],
                "resourceVersion": "1121",
                "uid": "c004300d-ce66-4e26-a85c-38409a31e611"
            },
            "spec": {
                "requestedIPCount": 0
            },
            "status": {
                "assignedIPCount": 512,
                "networkContainers": [
                    {
                        "assignmentMode": "static",
                        "id": "5e949e3d-82aa-461e-ab5e-d431f3ca4bd9",
                        "nodeIP": "10.224.0.6",
                        "primaryIP": "10.244.2.0/24",
                        "subnetAddressSpace": "10.244.0.0/16",
                        "subnetName": "routingdomain_b12b2d74-7eab-5ab9-9f68-1839bb52a384_overlaysubnet",
                        "type": "overlay",
                        "version": 0
                    },
                    {
                        "assignmentMode": "static",
                        "id": "beca6332-94f2-4c0a-b2e6-2d6e5a073f59",
                        "nodeIP": "10.224.0.6",
                        "primaryIP": "fdcb:b00:7545:bf38::200/120",
                        "subnetAddressSpace": "fdcb:b00:7545:bf38::/64",
                        "subnetName": "routingdomain_4c4572f6-230e-55b4-a532-0694a0a47798_overlaysubnet_ipv6",
                        "type": "overlay",
                        "version": 0
                    }
                ]
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```