# Azure Machine Learning Extension on an AKS cluster running Azure CNI powered by Cilium

- With Azure Machine Learning CLI/Python SDK v2, Azure Machine Learning introduced a new compute target - Kubernetes compute target. You can easily enable an existing Azure Kubernetes Service (AKS) cluster to become a Kubernetes compute target in Azure Machine Learning and use it to train or deploy models.
With your self-managed AKS cluster in Azure, you can gain security and controls to meet compliance requirements and flexibility to manage teams' ML workload.
With a simple cluster extension deployment on AKS or Arc Kubernetes cluster, the Kubernetes cluster is seamlessly supported in Azure Machine Learning to run training or inference workloads.

- Create a Resource Group
```
az group create --name azml --location westcentralus
```

- Register and add the extensions
```
#az extension add --name k8s-extension
Default enabled including preview versions for extension installation now. Disabled in May 2024. Use '--allow-preview true' to enable it specifically if needed. Use '--allow-preview false' to install stable version only.
#az extension  add -n ml
```

- For Azure Machine Learning extension deployment on AKS cluster, make sure to specify managedClusters value for --cluster-type parameter. Run the following Azure CLI command to deploy Azure Machine Learning extension:

```
# az k8s-extension create --name azml  --extension-type Microsoft.AzureML.Kubernetes --config enableTraining=True enableInference=True inferenceRouterServiceType=LoadBalancer allowInsecureConnections=True InferenceRouterHA=False --cluster-type managedClusters --cluster-name azml --resource-group azml --scope cluster
```

- Create an AKS cluster
```
#az aks create -n azml -g azml -l francecentral \\
  --network-plugin azure \\
  --network-plugin-mode overlay \\
  --pod-cidr 192.168.0.0/16 \\
  --network-dataplane cilium
```
- Attach a Kubernetes cluster to the Azure Machine Learning workspace. Once the Azure Machine Learning extension is deployed on the AKS cluster, you can attach the Kubernetes cluster to the Azure Machine Learning workspace and create compute targets for ML professionals.

```
#az ml workspace create -n azml -g azml
```

- Attach a Kubernetes cluster to the Azure Machine Learning workspace

```
#az ml compute attach --resource-group azml --workspace-name azml --type Kubernetes --name k8s-compute --resource-id "/subscriptions/####################################/resourceGroups/azml/providers/Microsoft.ContainerService/managedclusters/azml" --identity-type SystemAssigned --namespace azureml --no-wait
```

- Check that the pods are up and running
```
#kubectl get pods -A -o wide
NAMESPACE     NAME                                                     READY   STATUS      RESTARTS   AGE    IP              NODE                                NOMINATED NODE   READINESS GATES
azureml       aml-operator-6f9fbb5c6-hlf7f                             2/2     Running     0          3d2h   192.168.1.231   aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       amlarc-identity-controller-68cf5dd8b5-srshb              2/2     Running     0          3d2h   192.168.1.236   aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       amlarc-identity-proxy-5d5bb99f56-jbrrx                   2/2     Running     0          3d2h   192.168.2.248   aks-nodepool1-10287945-vmss000000   <none>           <none>
azureml       azml-kube-state-metrics-bbb9b749c-nvvgs                  1/1     Running     0          3d8h   192.168.2.71    aks-nodepool1-10287945-vmss000000   <none>           <none>
azureml       azml-prometheus-operator-7f6466cc44-wxpwv                1/1     Running     0          3d8h   192.168.1.161   aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       azureml-fe-v2-76b9b8bfff-4rmhc                           4/4     Running     0          3d2h   192.168.2.246   aks-nodepool1-10287945-vmss000000   <none>           <none>
azureml       azureml-fe-v2-76b9b8bfff-rw5mt                           4/4     Running     0          3d2h   192.168.1.77    aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       azureml-fe-v2-76b9b8bfff-zjqkn                           4/4     Running     0          3d2h   192.168.0.23    aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       azureml-ingress-nginx-controller-58c8c98cd9-66zhm        1/1     Running     0          3d8h   192.168.0.149   aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       gateway-7f969684dc-2lxzh                                 2/2     Running     0          3d2h   192.168.0.192   aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       healthcheck                                              0/1     Completed   0          138m   192.168.0.161   aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       inference-operator-controller-manager-5f5bd65867-c6c4r   2/2     Running     0          3d2h   192.168.1.56    aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       metrics-controller-manager-7c6d7dcdf4-ph4x9              2/2     Running     0          3d2h   192.168.1.225   aks-nodepool1-10287945-vmss000001   <none>           <none>
azureml       prometheus-prom-prometheus-0                             2/2     Running     0          3d2h   192.168.2.22    aks-nodepool1-10287945-vmss000000   <none>           <none>
azureml       volcano-admission-665df9d565-c9k94                       1/1     Running     0          3d2h   192.168.0.227   aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       volcano-controllers-5555c45f8d-qxprn                     1/1     Running     0          3d2h   192.168.0.202   aks-nodepool1-10287945-vmss000002   <none>           <none>
azureml       volcano-scheduler-694d688b9-mfphc                        1/1     Running     0          3d2h   192.168.0.214   aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   azure-cns-77mdr                                          1/1     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   azure-cns-hh9sv                                          1/1     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   azure-cns-mnhtc                                          1/1     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   azure-ip-masq-agent-9sfs9                                1/1     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   azure-ip-masq-agent-lqlzk                                1/1     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   azure-ip-masq-agent-m7qpm                                1/1     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   cilium-njtpd                                             1/1     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   cilium-operator-864b7c4bd6-97fq7                         1/1     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   cilium-operator-864b7c4bd6-fpf6t                         1/1     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   cilium-qj67v                                             1/1     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   cilium-szv2d                                             1/1     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   cloud-node-manager-7g88w                                 1/1     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   cloud-node-manager-zjl92                                 1/1     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   cloud-node-manager-zl4xn                                 1/1     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   coredns-789789675-hzp8v                                  1/1     Running     0          3d9h   192.168.1.130   aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   coredns-789789675-zs6vg                                  1/1     Running     0          3d9h   192.168.2.51    aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   coredns-autoscaler-649b947bbd-rtjbv                      1/1     Running     0          3d9h   192.168.1.198   aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-47c5w                                 3/3     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-blzn2                                 3/3     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   csi-azuredisk-node-kk9pq                                 3/3     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-c2g2b                                 3/3     Running     0          3d9h   10.224.0.5      aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   csi-azurefile-node-h7jgl                                 3/3     Running     0          3d9h   10.224.0.4      aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-vc4kg                                 3/3     Running     0          3d9h   10.224.0.6      aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   extension-agent-55d4f4795f-kb44s                         2/2     Running     0          3d8h   192.168.1.84    aks-nodepool1-10287945-vmss000001   <none>           <none>
kube-system   extension-operator-56c8d5f96c-pk99q                      2/2     Running     0          3d8h   192.168.0.111   aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   konnectivity-agent-574c7fc69c-4k6j5                      1/1     Running     0          3d8h   192.168.2.2     aks-nodepool1-10287945-vmss000000   <none>           <none>
kube-system   konnectivity-agent-574c7fc69c-pmp6b                      1/1     Running     0          3d8h   192.168.0.211   aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   metrics-server-5897c748b8-clwft                          2/2     Running     0          3d9h   192.168.0.185   aks-nodepool1-10287945-vmss000002   <none>           <none>
kube-system   metrics-server-5897c748b8-sv2lz                          2/2     Running     0          3d9h   192.168.2.148   aks-nodepool1-10287945-vmss000000   <none>           <none>
```