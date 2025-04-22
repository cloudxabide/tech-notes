# Load Balancer Permissions

```
- Microsoft.Network/virtualNetworks/subnets/join/action
- Microsoft.Network/virtualNetworks/subnets/read
```

```
Warning  SyncLoadBalancerFailed  2m42s (x6 over 5m18s)  service-controller  Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"LinkedAuthorizationFailed","message":"The client '################################' with object id '################################' has permission to perform action 'Microsoft.Network/loadBalancers/write' on scope '/subscriptions/################################/resourceGroups/mc_azurecilium_azurecilium_canadacentral/providers/Microsoft.Network/loadBalancers/kubernetes-internal'; however, it does not have permission to perform action(s) 'Microsoft.Network/virtualNetworks/subnets/join/action' on the linked scope(s) '/subscriptions/################################/resourceGroups/azurecilium/providers/Microsoft.Network/virtualNetworks/azurecilium-vnet/subnets/azurecilium-subnet' (respectively) or the linked scope(s) are invalid."}}
Normal   EnsuringLoadBalancer    2s (x7 over 5m18s)     service-controller  Ensuring load balancer
```

```
Warning  SyncLoadBalancerFailed  53s (x5 over 2m8s)  service-controller  Error syncing load balancer: failed to ensure load balancer: Retriable: false, RetryAfter: 0s, HTTPStatusCode: 403, RawError: {"error":{"code":"AuthorizationFailed","message":"The client '################################' with object id '################################' does not have authorization to perform action 'Microsoft.Network/virtualNetworks/subnets/read' over scope '/subscriptions/################################/resourceGroups/azurecilium/providers/Microsoft.Network/virtualNetworks/azurecilium-vnet/subnets/azurecilium-subnet' or the scope is invalid. If access was recently granted, please refresh your credentials."}}
```