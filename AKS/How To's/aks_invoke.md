# How to access your private AKS cluster using AKS Invoke?

When you access a private AKS cluster, you need to connect to the cluster from the cluster virtual network, a peered network, or a configured private endpoint. These approaches require configuring a VPN, Express Route, deploying a jumpbox within the cluster virtual network, or creating a private endpoint inside of another virtual network.

With the Azure CLI, you can use command invoke to access private clusters without the need to configure a VPN or Express Route. command invoke allows you to remotely invoke commands, like kubectl and helm, on your private cluster through the Azure API without directly connecting to the cluster.

```
az aks command invoke \
  --resource-group prvaksvnet \
  --name prvaks \
  --command "kubectl get pods -n kube-system"
command started at 2024-02-19 06:26:24+00:00, finished at 2024-02-19 06:26:24+00:00 with exitcode=0
NAME                                  READY   STATUS    RESTARTS       AGE
azure-cns-5w2zk                       1/1     Running   0              8d
azure-cns-82bgw                       1/1     Running   0              8d
azure-cns-vlc9g                       1/1     Running   0              8d
azure-ip-masq-agent-bmwzb             1/1     Running   0              8d
azure-ip-masq-agent-sr4hk             1/1     Running   0              8d
azure-ip-masq-agent-x89f6             1/1     Running   0              8d
cilium-kd5tj                          1/1     Running   0              3d23h
cilium-mjjbk                          1/1     Running   0              3d23h
cilium-operator-d78f778f7-7zvs9       1/1     Running   0              3d23h
cilium-operator-d78f778f7-ghm5g       1/1     Running   1 (3d9h ago)   3d23h
cilium-vftrz                          1/1     Running   0              3d23h
cloud-node-manager-8b74n              1/1     Running   0              8d
cloud-node-manager-d55lx              1/1     Running   0              8d
cloud-node-manager-ngmf4              1/1     Running   0              8d
coredns-789789675-qc9kn               1/1     Running   0              8d
coredns-789789675-w4v84               1/1     Running   0              8d
coredns-autoscaler-649b947bbd-hxqwr   1/1     Running   0              8d
csi-azuredisk-node-j4jkg              3/3     Running   0              8d
csi-azuredisk-node-l42qt              3/3     Running   0              8d
csi-azuredisk-node-vjp2q              3/3     Running   0              8d
csi-azurefile-node-m565p              3/3     Running   0              8d
csi-azurefile-node-xr75n              3/3     Running   0              8d
csi-azurefile-node-xzwhs              3/3     Running   0              8d
extension-agent-55d4f4795f-pktc6      2/2     Running   0              3d23h
extension-operator-56c8d5f96c-9sgqx   2/2     Running   0              3d23h
hubble-relay-76ff659b59-vkrsf         1/1     Running   0              3d23h
konnectivity-agent-54c85967cb-7tbxr   1/1     Running   0              8d
konnectivity-agent-54c85967cb-mgfdg   1/1     Running   0              8d
metrics-server-5467676b76-7xmh8       2/2     Running   0              8d
metrics-server-5467676b76-kg9l6       2/2     Running   0              8d
```