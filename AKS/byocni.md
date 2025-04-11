## What’s in store for Cilium with BYOCNI?

- Installing Cilium in this mode does not have limitations around unmanaged pods because new nodes will wait to get picked up by Cilium before pods are scheduled. However, it does not integrate with the Azure API at all.
- BYOCNI is not a Cilium feature, but to work on BYOCNI, Cilium uses VXLAN + Cluster Pool IPAM , which are both stable.
    - At the same time, Cilium has limitations on what It can use on BYOCNI, such as **direct routing**.

## Key points while bringing up an AKS cluster in BYOCNI mode

- The cluster identity used by the AKS cluster must have at least [Network Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#network-contributor) permissions on the subnet within your virtual network. If you wish to define a [custom role](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles) instead of using the built-in Network Contributor role, the following permissions are required:
    - `Microsoft.Network/virtualNetworks/subnets/join/action`
    - `Microsoft.Network/virtualNetworks/subnets/read`
- The subnet assigned to the AKS node pool can't be [delegated](https://learn.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview).
- AKS doesn't apply Network Security Groups (NSGs) to its subnet or modify any NSGs associated with it. If you provide your subnet and add NSGs associated with that subnet, you must ensure the security rules in the NSGs allow traffic within the node CIDR range.

## Support from Microsoft

- Microsoft support can't assist with CNI-related issues in clusters deployed with Bring your own Container Network Interface (BYOCNI). For example, CNI-related issues would cover most east/west (pod to pod) traffic, along with `kubectl proxy` and similar commands.
- If you want CNI-related support, use a supported AKS network plugin or seek support from the BYOCNI plugin third-party vendor.
- Support is still provided for non-CNI-related issues.