# Infiniband

- InfiniBand is a powerful new architecture designed to support I/O connectivity for the Internet infrastructure. InfiniBand is supported by all the major OEM server vendors as a means to expand beyond and create the next generation I/O interconnect standard in servers.

- Remote Direct Memory Access (RDMA) over InfiniBand: Similar to driving a race car on the fast InfiniBand highway. It maximizes speed and performance but may require specific application design and networking configuration to operate these race cars on the race car highway.
- IP over InfiniBand (IPoIB): This is comparable to regular cars using the race car highway - may be easy to implement and compatible with off-the-shelf applications, but you don’t get the full speed benefits.

### Infiniband on AKS

- Create a Resource Group
```
az group create --name azrdma --location uksouth
```
- Register and add the extensions
```
az provider register --namespace Microsoft.ContainerService --wait
az provider register --namespace Microsoft.KubernetesConfiguration --wait
```

```
az extension add --name k8s-extension
Default enabled including preview versions for extension installation now. Disabled in May 2024. Use '--allow-preview true' to enable it specifically if needed. Use '--allow-preview false' to install stable version only.
```
- Create an AKS cluster
```
az aks create -n azrdma -g azrdma \\
  --location uksouth \\
  --network-plugin azure \\
  --network-plugin-mode overlay \\
  --pod-cidr 192.168.0.0/16
```
- Add a nodegroup based on HBv3 and HBv4 HPC VM sizes that support Infiniband on AKS.
```
az aks nodepool add --resource-group azrdma --cluster-name azrdma --name rdmanp --node-count 2 --node-vm-size Standard_HB120rs_v3
{
  "availabilityZones": null,
  "capacityReservationGroupId": null,
  "count": 2,
  "creationData": null,
  "currentOrchestratorVersion": "1.27.9",
  "enableAutoScaling": false,
  "enableEncryptionAtHost": false,
  "enableFips": false,
  "enableNodePublicIp": false,
  "enableUltraSsd": false,
  "gpuInstanceProfile": null,
  "hostGroupId": null,
  "id": "/subscriptions/#####################################/resourcegroups/test/providers/Microsoft.ContainerService/managedClusters/test/agentPools/rdmanp",
  "kubeletConfig": null,
  "kubeletDiskType": "OS",
  "linuxOsConfig": null,
  "maxCount": null,
  "maxPods": 250,
  "minCount": null,
  "mode": "User",
  "name": "rdmanp",
  "networkProfile": null,
  "nodeImageVersion": "AKSUbuntu-2204gen2containerd-202402.26.0",
  "nodeLabels": null,
  "nodePublicIpPrefixId": null,
  "nodeTaints": null,
  "orchestratorVersion": "1.27.9",
  "osDiskSizeGb": 128,
  "osDiskType": "Ephemeral",
  "osSku": "Ubuntu",
  "osType": "Linux",
  "podSubnetId": null,
  "powerState": {
    "code": "Running"
  },
  "provisioningState": "Succeeded",
  "proximityPlacementGroupId": null,
  "resourceGroup": "test",
  "scaleDownMode": "Delete",
  "scaleSetEvictionPolicy": null,
  "scaleSetPriority": null,
  "spotMaxPrice": null,
  "tags": null,
  "type": "Microsoft.ContainerService/managedClusters/agentPools",
  "typePropertiesType": "VirtualMachineScaleSets",
  "upgradeSettings": {
    "drainTimeoutInMinutes": null,
    "maxSurge": null,
    "nodeSoakDurationInMinutes": null
  },
  "vmSize": "Standard_HB120rs_v3",
  "vnetSubnetId": null,
  "workloadRuntime": null
}
```
- Ensure that the nodes are up and running
```
kubectl get nodes -A -o wide
NAME                                STATUS   ROLES   AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
aks-nodepool1-27006571-vmss000000   Ready    agent   3h20m   v1.27.9   10.224.0.4    <none>        Ubuntu 22.04.4 LTS   5.15.0-1057-azure   containerd://1.7.7-1
aks-nodepool1-27006571-vmss000001   Ready    agent   3h19m   v1.27.9   10.224.0.5    <none>        Ubuntu 22.04.4 LTS   5.15.0-1057-azure   containerd://1.7.7-1
aks-nodepool1-27006571-vmss000002   Ready    agent   3h17m   v1.27.9   10.224.0.6    <none>        Ubuntu 22.04.4 LTS   5.15.0-1057-azure   containerd://1.7.7-1
aks-rdmanp-41231752-vmss000000      Ready    agent   111s    v1.27.9   10.224.0.7    <none>        Ubuntu 22.04.4 LTS   5.15.0-1057-azure   containerd://1.7.7-1
aks-rdmanp-41231752-vmss000001      Ready    agent   78s     v1.27.9   10.224.0.8    <none>        Ubuntu 22.04.4 LTS   5.15.0-1057-azure   containerd://1.7.7-1
```