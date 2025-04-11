# This is applicable to the case when we spin up an AKS cluster running Cilium as an add-on/extension.

- **Add-ons**
    
    Add-ons are a fully supported way to provide extra capabilities for your AKS cluster. The installation, configuration, and lifecycle of add-ons is managed by AKS. You can use the [`az aks enable-addons`](https://learn.microsoft.com/en-us/cli/azure/aks#az-aks-enable-addons) command to install an add-on or manage the add-ons for your cluster.
    
    AKS uses the following rules for applying updates to installed add-ons:
    
    - Only an add-on's patch version can be upgraded within a Kubernetes minor version. The add-on's major/minor version isn't upgraded within the same Kubernetes minor version.
    - The major/minor version of the add-on is only upgraded when moving to a later Kubernetes minor version.
    - Any breaking or behavior changes to the add-on are announced well before, usually 60 days, for a GA minor version of Kubernetes on AKS.
    - You can patch add-ons weekly with every new release of AKS, which is announced in the release notes. You can control AKS releases using the [maintenance windows](https://learn.microsoft.com/en-us/azure/aks/planned-maintenance) and [release tracker](https://learn.microsoft.com/en-us/azure/aks/release-tracker).
- **Extensions**
    
    Cluster extensions build on top of certain Helm charts and provide an Azure Resource Manager-driven experience for the installation and lifecycle management of different Azure capabilities on top of your Kubernetes cluster.
    
    - For more information on the specific cluster extensions for AKS, see [Deploy and manage cluster extensions for Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/cluster-extensions?tabs=azure-cli).
    - For more information on available cluster extensions, see [Currently available extensions](https://learn.microsoft.com/en-us/azure/aks/cluster-extensions?tabs=azure-cli#currently-available-extensions).
    
- **Difference between extensions and add-ons**
    - Extensions and add-ons are both supported ways to add functionality to your AKS cluster. When you install an add-on, the functionality is added as part of the AKS resource provider in the Azure API. When you install an extension, the functionality is added as part of a separate resource provider in the Azure API.