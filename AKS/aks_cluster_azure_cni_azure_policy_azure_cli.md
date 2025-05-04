# An AKS cluster with the network plugin as Azure CNI with Azure as the Network Policy.

1. Create an AKS cluster with Network plugin as Azure CNI.

```
az group create --name nwpluginazurecniazurepolicy --location australiaeast

az network vnet create \
    --resource-group nwpluginazurecniazurepolicy \
    --name nwpluginazurecniazurepolicy \
    --address-prefixes 192.168.0.0/16 \
    --subnet-name nwpluginazurecniazurepolicy \
    --subnet-prefix 192.168.1.0/24

SUBNET_ID=$(az network vnet subnet show --resource-group nwpluginazurecniazurepolicy --vnet-name nwpluginazurecniazurepolicy --name nwpluginazurecniazurepolicy --query id -o tsv)

az aks create \
    --resource-group nwpluginazurecniazurepolicy \
    --name nwpluginazurecniazurepolicy \
    --node-count 2 \
    --network-plugin azure --network-policy azure \
    --vnet-subnet-id $SUBNET_ID

az aks get-credentials --resource-group nwpluginazurecniazurepolicy --name nwpluginazurecniazurepolicy
```

1. Verify that all pods are up and running

```
kubectl get pods -A -o wide
NAMESPACE     NAME                                  READY   STATUS    RESTARTS   AGE   IP             NODE                                NOMINATED NODE   READINESS GATES
kube-system   azure-ip-masq-agent-jfhtv             1/1     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   azure-ip-masq-agent-k474f             1/1     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   azure-npm-lgv4d                       1/1     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   azure-npm-vnk95                       1/1     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   cloud-node-manager-4jcns              1/1     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   cloud-node-manager-gskq4              1/1     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   coredns-76b9877f49-lvq2h              1/1     Running   0          20h   192.168.1.13   aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   coredns-76b9877f49-sh2lz              1/1     Running   0          20h   192.168.1.50   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   coredns-autoscaler-85f7d6b75d-vmnfl   1/1     Running   0          20h   192.168.1.23   aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-62zj5              3/3     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   csi-azuredisk-node-dwc8p              3/3     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-v7fmj              3/3     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   csi-azurefile-node-xt9c9              3/3     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   konnectivity-agent-7bb7558cf8-mdk27   1/1     Running   0          20h   192.168.1.20   aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   konnectivity-agent-7bb7558cf8-qqfmh   1/1     Running   0          20h   192.168.1.38   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   kube-proxy-dvx79                      1/1     Running   0          20h   192.168.1.4    aks-nodepool1-29364957-vmss000001   <none>           <none>
kube-system   kube-proxy-hjpl4                      1/1     Running   0          20h   192.168.1.33   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   metrics-server-555d76c778-66s8q       2/2     Running   0          20h   192.168.1.44   aks-nodepool1-29364957-vmss000000   <none>           <none>
kube-system   metrics-server-555d76c778-cf7p6       2/2     Running   0          20h   192.168.1.40   aks-nodepool1-29364957-vmss000000   <none>           <none>
```

1. Routing table on the node

```
route -nv
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    100    0        0 eth0
168.63.129.16   192.168.1.1     255.255.255.255 UGH   100    0        0 eth0
169.254.169.254 192.168.1.1     255.255.255.255 UGH   100    0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     100    0        0 eth0
192.168.1.1     0.0.0.0         255.255.255.255 UH    100    0        0 eth0
192.168.1.38    0.0.0.0         255.255.255.255 UH    0      0        0 azvcd87e76d4de
192.168.1.40    0.0.0.0         255.255.255.255 UH    0      0        0 azve2d109806b3
192.168.1.44    0.0.0.0         255.255.255.255 UH    0      0        0 azveeef4bfc05d
192.168.1.50    0.0.0.0         255.255.255.255 UH    0      0        0 azv431b324e9b7
```

1. Interfaces on the node

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:22:48:92:3f:b2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.33/24 metric 100 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::222:48ff:fe92:3fb2/64 scope link
       valid_lft forever preferred_lft forever
3: enP56697s1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master eth0 state UP group default qlen 1000
    link/ether 00:22:48:92:3f:b2 brd ff:ff:ff:ff:ff:ff
    altname enP56697p0s2
5: azv431b324e9b7@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:aa:aa:aa:aa:aa brd ff:ff:ff:ff:ff:ff link-netns cni-5532cb0f-765a-286d-21b1-c697f138b161
    inet6 fe80::a8aa:aaff:feaa:aaaa/64 scope link
       valid_lft forever preferred_lft forever
7: azveeef4bfc05d@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:aa:aa:aa:aa:aa brd ff:ff:ff:ff:ff:ff link-netns cni-553cdfef-2b63-9c71-5095-99929032de1e
    inet6 fe80::a8aa:aaff:feaa:aaaa/64 scope link
       valid_lft forever preferred_lft forever
9: azve2d109806b3@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:aa:aa:aa:aa:aa brd ff:ff:ff:ff:ff:ff link-netns cni-21dfc9c1-b4a1-a6db-01ea-17f16c5c8c13
    inet6 fe80::a8aa:aaff:feaa:aaaa/64 scope link
       valid_lft forever preferred_lft forever
11: azvcd87e76d4de@if10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether aa:aa:aa:aa:aa:aa brd ff:ff:ff:ff:ff:ff link-netns cni-1b03eefd-51fe-2a0f-eceb-014b09d632c0
    inet6 fe80::a8aa:aaff:feaa:aaaa/64 scope link
       valid_lft forever preferred_lft forever
```

1. Azure CNI

```json
{
   "cniVersion":"0.3.0",
   "name":"azure",
   "plugins":[
      {
         "type":"azure-vnet",
         "mode":"transparent",
         "ipsToRouteViaHost":["169.254.20.10"],
         "ipam":{
            "type":"azure-vnet-ipam"
         }
      },
      {
         "type":"portmap",
         "capabilities":{
            "portMappings":true
         },
         "snat":true
      }
   ]
}
```

1. iptables are prefixed with “azure-npm”

```
iptables --list-rules
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N AZURE-NPM
-N AZURE-NPM-ACCEPT
-N AZURE-NPM-EGRESS
-N AZURE-NPM-EGRESS-3618314628
-N AZURE-NPM-INGRESS
-N AZURE-NPM-INGRESS-ALLOW-MARK
-N KUBE-EXTERNAL-SERVICES
-N KUBE-FIREWALL
-N KUBE-FORWARD
-N KUBE-KUBELET-CANARY
-N KUBE-NODEPORTS
-N KUBE-PROXY-CANARY
-N KUBE-PROXY-FIREWALL
-N KUBE-SERVICES
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -j AZURE-NPM
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -d 168.63.129.16/32 -p tcp -m tcp --dport 80 -j DROP
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A AZURE-NPM -j AZURE-NPM-INGRESS
-A AZURE-NPM -j AZURE-NPM-EGRESS
-A AZURE-NPM -j AZURE-NPM-ACCEPT
-A AZURE-NPM-ACCEPT -j ACCEPT
-A AZURE-NPM-EGRESS -m set --match-set azure-npm-4272224941 src -m set --match-set azure-npm-2064349730 src -m comment --comment "EGRESS-POLICY-kube-system/konnectivity-agent-FROM-podlabel-app:konnectivity-agent-AND-ns-kube-system-IN-ns-kube-system" -j AZURE-NPM-EGRESS-3618314628
-A AZURE-NPM-EGRESS -m mark --mark 0x800/0x800 -m comment --comment "DROP-ON-EGRESS-DROP-MARK-0x800/0x800" -j DROP
-A AZURE-NPM-EGRESS -m mark --mark 0x200/0x200 -m comment --comment "ACCEPT-ON-INGRESS-ALLOW-MARK-0x200/0x200" -j AZURE-NPM-ACCEPT
-A AZURE-NPM-EGRESS-3618314628 -m comment --comment ALLOW-ALL -j AZURE-NPM-ACCEPT
-A AZURE-NPM-INGRESS -m mark --mark 0x400/0x400 -m comment --comment "DROP-ON-INGRESS-DROP-MARK-0x400/0x400" -j DROP
-A AZURE-NPM-INGRESS-ALLOW-MARK -m comment --comment "SET-INGRESS-ALLOW-MARK-0x200/0x200" -j MARK --set-xmark 0x200/0x200
-A AZURE-NPM-INGRESS-ALLOW-MARK -j AZURE-NPM-EGRESS
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```