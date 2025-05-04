# How to enable preview Features?

## Register resource providers
```
#az provider register --namespace Microsoft.ContainerService --wait
#az provider register --namespace Microsoft.KubernetesConfiguration --wait
```


## KataVMIsovalation
```
#az feature register --namespace "Microsoft.ContainerService" --name "KataVMIsolationPreview"
Once the feature 'KataVMIsolationPreview' is registered, invoking 'az provider register -n Microsoft.ContainerService' is required to get the change propagated
{
  "id": "/subscriptions/##############################/providers/Microsoft.Features/providers/Microsoft.ContainerService/features/KataVMIsolationPreview",
  "name": "Microsoft.ContainerService/KataVMIsolationPreview",
  "properties": {
    "state": "Registering"
  },
  "type": "Microsoft.Features/providers/features"
}
```

```
az feature show --namespace "Microsoft.ContainerService" --name "KataVMIsolationPreview" -o table
Name                                               RegistrationState
-------------------------------------------------  -------------------
Microsoft.ContainerService/KataVMIsolationPreview  Registered
```
## How to verify Isovalent Enterprise for Cilium Extension Installed in Azure Marketplace?

- Verify the deployment by using the following command to list the extensions that are running on your cluster.
```
#az k8s-extension show --cluster-name <clusterName> --resource-group <resourceGroupName> --cluster-type managedClusters -n cilium
```
- You can delete a purchased plan for an Azure container offer by deleting the extension instance on the cluster.
```
#az k8s-extension delete --cluster-name <clusterName> --resource-group <resourceGroupName> --cluster-type managedClusters -n cilium
```
- Accept terms and agreements. Before deploying a Kubernetes application, you must accept its terms and agreements.
```
#az vm image terms accept --offer <Product ID> --plan <Plan ID> --publisher <Publisher ID>
```