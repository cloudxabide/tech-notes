# What is Azure CNI Overlay?

## Brief
With Azure CNI Overlay, the cluster nodes are deployed into an Azure Virtual Network (VNet) subnet. 

- Pods are assigned IP addresses from a private CIDR logically different from the VNet hosting the nodes.
- Pod and node traffic within the cluster use an Overlay network. Network Address Translation (NAT) uses the node's IP address to reach resources outside the cluster.
- This solution saves a significant amount of VNet IP addresses and enables you to scale your cluster to large sizes.
- An extra advantage is that you can reuse the private CIDR in different AKS clusters, which extends the IP space available for containerized applications in Azure Kubernetes Service (AKS).

## Overview

- In Overlay networking, only the Kubernetes cluster nodes are assigned IPs from a subnet. Pods receive IPs from a private CIDR provided at the time of cluster creation. Each node is assigned a `/24` address space carved out from the same CIDR. Extra nodes created when you scale out a cluster automatically receive `/24` address spaces from the same CIDR. Azure CNI assigns IPs to pods from this `/24` space.
- A separate routing domain is created in the Azure Networking stack for the pod's private CIDR space, which creates an Overlay network for direct communication between pods.
- There's no need to provision custom routes on the cluster subnet or use an encapsulation method to tunnel traffic between pod, which provides connectivity performance between pods on par with VMs in a VNet.
- Communication with endpoints outside the cluster, such as on-premises and peered VNets, happens using the node IP through NAT. Azure CNI translates the source IP (Overlay IP of the pod) of the traffic to the primary IP address of the VM, which enables the Azure Networking stack to route the traffic to the destination. Endpoints outside the cluster can't connect to a pod directly. You have to publish the pod's application as a Kubernetes Load Balancer service to make it reachable on the VNet.
- You can provide outbound (egress) connectivity to the internet for Overlay pods using a Standard SKU Load Balancer or managed NAT Gateway. You can also control egress traffic by directing it to a firewall using User Defined Routes on the cluster subnet.
- You can configure ingress connectivity to the cluster using an ingress controller, such as Nginx or HTTP application routing.

## **Limitations with Azure CNI Overlay**

- You can't use Application Gateway as an Ingress Controller (AGIC) for an Overlay cluster.
- Virtual Machine Availability Sets (VMAS) aren't supported for Overlay.
- Dual stack networking isn't supported in Overlay.