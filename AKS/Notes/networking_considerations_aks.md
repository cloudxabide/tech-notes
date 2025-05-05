**On 31 March 2028, kubenet networking for Azure Kubernetes Service (AKS) will be retired.**

## **Maximum pods per node**

- The maximum number of pods per node in an AKS cluster is 250. The *default* maximum number of pods per node varies between *kubenet* and *Azure CNI* networking, and the method of cluster deployment.

| **Deployment method** | **Kubenet default** | **Azure CNI default** | **Configurable at deployment** |
| --- | --- | --- | --- |
| Azure CLI | 110 | 30 | Yes (up to 250) |
| Resource Manager template | 110 | 30 | Yes (up to 250) |
| Portal | 110 | 110 (configurable in the Node Pools tab) | Yes (up to 250) |

## **Configure maximum - new clusters**

- You're able to configure the maximum number of pods per node at cluster deployment time or as you add new node pools. You can set the maximum pods per node value as high as 250.
- If you don't specify maxPods when creating new node pools, you receive a default value of 30 for Azure CNI.
- A minimum value for maximum pods per node is enforced to guarantee space for system pods critical to cluster health. The minimum value that can be set for maximum pods per node is 10 if and only if the configuration of each node pool has space for a minimum of 30 pods. For example, setting the maximum number of pods per node to a minimum of 10 requires each individual node pool to have a minimum of 3 nodes. This requirement applies for each new node pool created as well, so if 10 is defined as maximum pods per node each subsequent node pool added must have at least 3 nodes.

| Networking | Minimum | Maximum |
| --- | --- | --- |
| Azure CNI | 10 | 250 |
| Kubenet | 10 | 250 |

## The Difference in Network Models

The following basic calculations compare the difference in network models:

- **kubenet**: A simple */24* IP address range can support up to *251* nodes in the cluster. Each Azure virtual network subnet reserves the first three IP addresses for management operations. This node count can support up to *27,610* pods, with a default maximum of 110 pods per node.
- **Azure CNI**: That same basic */24* subnet range can only support a maximum of *eight* nodes in the cluster. This node count can only support up to *240* pods, with a default maximum of 30 pods per node.

## Network Model to choose

### **Use *kubenet* when**:

- You have limited IP address space.
- Most of the pod communication is within the cluster.
- You don't need advanced AKS features, such as virtual nodes or Azure Network Policy.

### **Use *Azure CNI* when**:

- You have available IP address space.
- Most of the pod communication is to resources outside of the cluster.
- You don't want to manage user-defined routes for pod connectivity.
- You need AKS advanced features, such as virtual nodes or Azure Network Policy.

## Comparing Kubenet with Azure CNI

| **Capability** | **Kubenet** | **Azure CNI** |
| --- | --- | --- |
| Deploy cluster in an existing or new virtual network | Supported - UDRs manually applied | Supported |
| Pod-pod connectivity | Supported | Supported |
| Pod-VM connectivity; VM in the same virtual network | Works when initiated by a pod | Works both ways |
| Pod-VM connectivity; VM in a peered virtual network | Works when initiated by a pod | Works both ways |
| On-premises access using VPN or Express Route | Works when initiated by a pod | Works both ways |
| Access to resources secured by service endpoints | Supported | Supported |
| Expose Kubernetes services using a load balancer service, App Gateway, or ingress controller | Supported | Supported |
| Default Azure DNS and Private Zones | Supported | Supported |
| Support for Windows node pools | Not Supported | Supported |
| Virtual nodes | Not Supported | Supported |
| Multiple clusters sharing one subnet | Not supported | Supported |
| Network policies supported | Calico | Calico and Azure Network Policies |