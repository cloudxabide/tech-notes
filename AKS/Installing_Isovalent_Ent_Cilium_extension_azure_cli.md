# Isovalent Enterprise for Cilium can be installed from Azure Marketplace via Azure CLI.

- Creating the extension
```
#az k8s-extension create --name cilium --extension-type Isovalent.CiliumEnterprise.One --scope cluster --cluster-name ciliumossazmktplace  --resource-group ciliumossazmktplace --cluster-type managedClusters --plan-name isovalent-cilium-enterprise-base-edition --plan-product isovalent-cilium-enterprise --plan-publisher isovalentinc3222233121323
```
- Update the extension

```
#az k8s-extension show -c <cluster-name> -t managedClusters -g <resource-group> -n cilium
```
- Enabling Enterprise Features

```
#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings namespace=kube-system 

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings hubble.enabled=true 

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings hubble.relay.enabled=true

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings encryption.enabled=true

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings encryption.type=wireguard

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings l7Proxy=false

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings kubeProxyReplacement=strict

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings k8sServicePort=<API_SERVER_PORT>

#az k8s-extension update -c <cluster-name> -t managedClusters -g <resource-group> -n cilium --configuration-settings k8sServiceHost=<API_SERVER_FQDN>
```