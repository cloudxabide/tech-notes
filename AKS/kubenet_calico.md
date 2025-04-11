### Kubenet with Calico

***Note-*** Kubenet can be configured with network policy as Calico only. If you want to enable an AKS cluster to include a [**Calico network policy**](https://docs.projectcalico.org/v3.9/security/calico-network-policy), you can use the following command:

1. Create an AKS cluster with network-plugin as “kubenet”.

```json
az group create --name nwpluginkubenet --location eastus

az network vnet create \
    --resource-group nwpluginkubenet \
    --name nwpluginkubenet \
    --address-prefixes 192.168.0.0/16 \
    --subnet-name nwpluginkubenet \
    --subnet-prefix 192.168.1.0/24

SUBNET_ID=$(az network vnet subnet show --resource-group nwpluginkubenet --vnet-name nwpluginkubenet --name nwpluginkubenet --query id -o tsv)

az aks create \
    --resource-group nwpluginkubenet \
    --name nwpluginkubenet \
    --node-count 2 \
    --network-plugin kubenet --network-policy calico \
    --vnet-subnet-id $SUBNET_ID
```

1. Calico pods and the operator are configured as a part of a different namespace.

```json
kubectl get pods -A -o wide
NAMESPACE         NAME                                      READY   STATUS    RESTARTS   AGE   IP            NODE                                NOMINATED NODE   READINESS GATES
calico-system     calico-kube-controllers-97794b47f-7wwq9   1/1     Running   0          12h   10.244.0.4    aks-nodepool1-12355964-vmss000000   <none>           <none>
calico-system     calico-node-n87nz                         1/1     Running   0          11h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
calico-system     calico-node-vbz4z                         1/1     Running   0          11h   192.168.1.5   aks-nodepool1-12355964-vmss000001   <none>           <none>
calico-system     calico-typha-5b86b67dfb-b5kj6             1/1     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
default           nsenter-nn2t9w                            1/1     Running   0          72s   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       cloud-node-manager-c8jqj                  1/1     Running   0          12h   192.168.1.5   aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       cloud-node-manager-svmkg                  1/1     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       coredns-76b9877f49-5s9qp                  1/1     Running   0          11h   10.244.1.3    aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       coredns-76b9877f49-rr7kd                  1/1     Running   0          11h   10.244.1.2    aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       coredns-autoscaler-85f7d6b75d-cfg24       1/1     Running   0          12h   10.244.0.8    aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       csi-azuredisk-node-6lmbf                  3/3     Running   0          12h   192.168.1.5   aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       csi-azuredisk-node-k4vtg                  3/3     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       csi-azurefile-node-qb4gl                  3/3     Running   0          12h   192.168.1.5   aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       csi-azurefile-node-xcqg6                  3/3     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       konnectivity-agent-66687759b6-qlv4h       1/1     Running   0          11h   10.244.0.12   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       konnectivity-agent-66687759b6-t9rcp       1/1     Running   0          11h   10.244.1.4    aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       kube-proxy-dqfbl                          1/1     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       kube-proxy-jfndj                          1/1     Running   0          12h   192.168.1.5   aks-nodepool1-12355964-vmss000001   <none>           <none>
kube-system       metrics-server-555d76c778-5zsr9           2/2     Running   0          12h   10.244.0.10   aks-nodepool1-12355964-vmss000000   <none>           <none>
kube-system       metrics-server-555d76c778-wcrhh           2/2     Running   0          12h   10.244.0.11   aks-nodepool1-12355964-vmss000000   <none>           <none>
tigera-operator   tigera-operator-65b96c9d94-h4t49          1/1     Running   0          12h   192.168.1.4   aks-nodepool1-12355964-vmss000000   <none>           <none>
```

1. Node-level details show interfaces with prefixes as “calic”

```json
kubectl-node_shell aks-nodepool1-12355964-vmss000000
spawning "nsenter-nn2t9w" on "aks-nodepool1-12355964-vmss000000"
If you don't see a command prompt, try pressing enter.
root@aks-nodepool1-12355964-vmss000000:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:22:48:2b:07:8d brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.4/24 metric 100 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::222:48ff:fe2b:78d/64 scope link
       valid_lft forever preferred_lft forever
3: enP296s1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master eth0 state UP group default qlen 1000
    link/ether 00:22:48:2b:07:8d brd ff:ff:ff:ff:ff:ff
    altname enP296p0s2
6: cali55f439ddb0e@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-f6af2c94-4830-89ab-c5ec-4a79422bad54
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link
       valid_lft forever preferred_lft forever
10: cali26cecacb712@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-2ccd4597-a995-5457-98d7-d8e6ed096c9f
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link
       valid_lft forever preferred_lft forever
14: calic5a1f1aa0ed@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-cdf1dfe0-5f04-64e6-02a4-ca5f244beecf
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link
       valid_lft forever preferred_lft forever
15: cali112d888c0c2@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-84e1dd3f-77ef-c554-2741-88c5f74a3451
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link
       valid_lft forever preferred_lft forever
20: cali7f995c717f8@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether ee:ee:ee:ee:ee:ee brd ff:ff:ff:ff:ff:ff link-netns cni-03aa84aa-33e4-8121-b2aa-7b7ef9f9ed50
    inet6 fe80::ecee:eeff:feee:eeee/64 scope link
       valid_lft forever preferred_lft forever
```

1. Routing table on the node

```json
route -nv
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG    100    0        0 eth0
10.244.0.2      0.0.0.0         255.255.255.255 UH    0      0        0 calif6abb148530
10.244.0.4      0.0.0.0         255.255.255.255 UH    0      0        0 cali55f439ddb0e
10.244.0.5      0.0.0.0         255.255.255.255 UH    0      0        0 cali9d7310e16e7
10.244.0.8      0.0.0.0         255.255.255.255 UH    0      0        0 cali26cecacb712
10.244.0.10     0.0.0.0         255.255.255.255 UH    0      0        0 calic5a1f1aa0ed
10.244.0.11     0.0.0.0         255.255.255.255 UH    0      0        0 cali112d888c0c2
168.63.129.16   192.168.1.1     255.255.255.255 UGH   100    0        0 eth0
169.254.169.254 192.168.1.1     255.255.255.255 UGH   100    0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     100    0        0 eth0
192.168.1.1     0.0.0.0         255.255.255.255 UH    100    0        0 eth0
```

1. CNI mapping on the node

```json
cat 10-calico.conflist
{
  "name": "k8s-pod-network",
  "cniVersion": "0.3.1",
  "plugins": [
    {
      "type": "calico",
      "datastore_type": "kubernetes",
      "mtu": 0,
      "nodename_file_optional": false,
      "log_level": "Info",
      "log_file_path": "/var/log/calico/cni/cni.log",
      "ipam": { "type": "host-local", "subnet": "usePodCidr"},
      "container_settings": {
          "allow_ip_forwarding": true
      },
      "policy": {
          "type": "k8s"
      },
      "kubernetes": {
          "k8s_api_root":"https://nwpluginku-nwpluginkubenet-8dbd25-kkp3k8jh.hcp.eastus.azmk8s.io:443",
          "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
      }
    },
    {
      "type": "bandwidth",
      "capabilities": {"bandwidth": true}
    },
    {"type": "portmap", "snat": true, "capabilities": {"portMappings": true}}
  ]
}
```

1. With no service or app being deployed, we can clearly see a massive iptables list already present with Calico.

 

```json
iptables --list-rules
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N KUBE-EXTERNAL-SERVICES
-N KUBE-FIREWALL
-N KUBE-FORWARD
-N KUBE-KUBELET-CANARY
-N KUBE-NODEPORTS
-N KUBE-PROXY-CANARY
-N KUBE-PROXY-FIREWALL
-N KUBE-SERVICES
-N cali-FORWARD
-N cali-INPUT
-N cali-OUTPUT
-N cali-cidr-block
-N cali-from-hep-forward
-N cali-from-host-endpoint
-N cali-from-wl-dispatch
-N cali-fw-cali112d888c0c2
-N cali-fw-cali26cecacb712
-N cali-fw-cali55f439ddb0e
-N cali-fw-cali9d7310e16e7
-N cali-fw-calic5a1f1aa0ed
-N cali-fw-calif6abb148530
-N cali-po-_j5sVgQTfF-APgMw0kN9
-N cali-po-_rWDSk9LLgWIl_lpnJE2
-N cali-pri-_CVSZITRyIpEmH8AB6H
-N cali-pri-_b-WIgmNvlBH1FuEYm2
-N cali-pri-_npJ7qTPnQvugDgIE9J
-N cali-pri-_nzzjLvInId1gPHmQz_
-N cali-pri-kns.calico-system
-N cali-pri-kns.kube-system
-N cali-pro-_CVSZITRyIpEmH8AB6H
-N cali-pro-_b-WIgmNvlBH1FuEYm2
-N cali-pro-_npJ7qTPnQvugDgIE9J
-N cali-pro-_nzzjLvInId1gPHmQz_
-N cali-pro-kns.calico-system
-N cali-pro-kns.kube-system
-N cali-to-hep-forward
-N cali-to-host-endpoint
-N cali-to-wl-dispatch
-N cali-tw-cali112d888c0c2
-N cali-tw-cali26cecacb712
-N cali-tw-cali55f439ddb0e
-N cali-tw-cali9d7310e16e7
-N cali-tw-calic5a1f1aa0ed
-N cali-tw-calif6abb148530
-N cali-wl-to-host
-A INPUT -m comment --comment "cali:Cz_u1IQiXIMmKD4c" -j cali-INPUT
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A INPUT -m comment --comment "kubernetes health check service ports" -j KUBE-NODEPORTS
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m comment --comment "cali:wUHhoiAYhphO9Mso" -j cali-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A FORWARD -d 168.63.129.16/32 -p tcp -m tcp --dport 80 -j DROP
-A FORWARD -m comment --comment "cali:S93hcgKJrXEqnTfs" -m comment --comment "Policy explicitly accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A FORWARD -m comment --comment "cali:mp77cMpurHhyjLrM" -j MARK --set-xmark 0x10000/0x10000
-A OUTPUT -m comment --comment "cali:tVnHkvAo15HuiPy0" -j cali-OUTPUT
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes load balancer firewall" -j KUBE-PROXY-FIREWALL
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A KUBE-FIREWALL ! -s 127.0.0.0/8 -d 127.0.0.0/8 -m comment --comment "block incoming localnet connections" -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j DROP
-A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-FORWARD -m comment --comment "cali:vjrMJCRpqwy5oRoX" -j MARK --set-xmark 0x0/0xe0000
-A cali-FORWARD -m comment --comment "cali:A_sPAO0mcxbT9mOV" -m mark --mark 0x0/0x10000 -j cali-from-hep-forward
-A cali-FORWARD -i cali+ -m comment --comment "cali:8ZoYfO5HKXWbB3pk" -j cali-from-wl-dispatch
-A cali-FORWARD -o cali+ -m comment --comment "cali:jdEuaPBe14V2hutn" -j cali-to-wl-dispatch
-A cali-FORWARD -m comment --comment "cali:12bc6HljsMKsmfr-" -j cali-to-hep-forward
-A cali-FORWARD -m comment --comment "cali:NOSxoaGx8OIstr1z" -j cali-cidr-block
-A cali-INPUT -i cali+ -m comment --comment "cali:FewJpBykm9iJ-YNH" -g cali-wl-to-host
-A cali-INPUT -m comment --comment "cali:hder3ARWznqqv8Va" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-INPUT -m comment --comment "cali:xgOu2uJft6H9oDGF" -j MARK --set-xmark 0x0/0xf0000
-A cali-INPUT -m comment --comment "cali:_-d-qojMfHM6NwBo" -j cali-from-host-endpoint
-A cali-INPUT -m comment --comment "cali:LqmE76MP94lZTGhA" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-OUTPUT -m comment --comment "cali:Mq1_rAdXXH3YkrzW" -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-OUTPUT -o cali+ -m comment --comment "cali:69FkRTJDvD5Vu6Vl" -j RETURN
-A cali-OUTPUT -m comment --comment "cali:Fskumj4SGQtDV6GC" -j MARK --set-xmark 0x0/0xf0000
-A cali-OUTPUT -m comment --comment "cali:1F4VWEsQu0QbRwKf" -m conntrack ! --ctstate DNAT -j cali-to-host-endpoint
-A cali-OUTPUT -m comment --comment "cali:m8Eqm15x1MjD24LD" -m comment --comment "Host endpoint policy accepted packet." -m mark --mark 0x10000/0x10000 -j ACCEPT
-A cali-from-wl-dispatch -i cali112d888c0c2 -m comment --comment "cali:887K6j2m0yTxV8XZ" -g cali-fw-cali112d888c0c2
-A cali-from-wl-dispatch -i cali26cecacb712 -m comment --comment "cali:-1f18nv9_J5o_MPL" -g cali-fw-cali26cecacb712
-A cali-from-wl-dispatch -i cali55f439ddb0e -m comment --comment "cali:X28EvX2q55aZM8gM" -g cali-fw-cali55f439ddb0e
-A cali-from-wl-dispatch -i cali9d7310e16e7 -m comment --comment "cali:CxKCBaJmNdZnWGOY" -g cali-fw-cali9d7310e16e7
-A cali-from-wl-dispatch -i calic5a1f1aa0ed -m comment --comment "cali:ZPC1pWieGIBIr5A7" -g cali-fw-calic5a1f1aa0ed
-A cali-from-wl-dispatch -i calif6abb148530 -m comment --comment "cali:xDvXvF5yVFq7Y1QJ" -g cali-fw-calif6abb148530
-A cali-from-wl-dispatch -m comment --comment "cali:FUqQW1upEuPXcL7s" -m comment --comment "Unknown interface" -j DROP
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:gxYrST51OJyfBgWw" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:6xENQhO2T0QW5LgN" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:O7MDTYmYN54jUWVF" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali112d888c0c2 -p udp -m comment --comment "cali:pJp4jdAzPgU1geph" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali112d888c0c2 -p ipencap -m comment --comment "cali:rM5VAS66uaB9uI7_" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:s_9J1YgpafK_gEIJ" -j cali-pro-kns.kube-system
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:djdRyha1SrYGGpRJ" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:Agp1xuefUF89n6q7" -j cali-pro-_CVSZITRyIpEmH8AB6H
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:ctlnSZ9l6AD7YocC" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali112d888c0c2 -m comment --comment "cali:ThfJzx8K_BY2PCkD" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali26cecacb712 -m comment --comment "cali:sx01et1AaD3rVrYt" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali26cecacb712 -m comment --comment "cali:ayM14TUcMmlsfHfm" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali26cecacb712 -m comment --comment "cali:xM7aZ5Dg0bS2p8-k" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali26cecacb712 -p udp -m comment --comment "cali:Ah8ejTB2Y4cAiG1X" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali26cecacb712 -p ipencap -m comment --comment "cali:2VTtKdQOt_5JUGsP" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali26cecacb712 -m comment --comment "cali:IPpE8Z7TLB1in456" -j cali-pro-kns.kube-system
-A cali-fw-cali26cecacb712 -m comment --comment "cali:uRLk3oDpqE3OIVbt" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali26cecacb712 -m comment --comment "cali:pO1dZaz9o-0RbNSq" -j cali-pro-_npJ7qTPnQvugDgIE9J
-A cali-fw-cali26cecacb712 -m comment --comment "cali:qI1Jigoiv8rzXT4v" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali26cecacb712 -m comment --comment "cali:nODQvoCZTZSxUn5H" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:ZE14zB9YKq4f4bDY" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:WZoCuRzL6U1kEcHm" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:9gSqNKYFp-79S0sM" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali55f439ddb0e -p udp -m comment --comment "cali:qHUJ-SxK4x0eF7F-" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali55f439ddb0e -p ipencap -m comment --comment "cali:eD4_OFFVSVrO-VYv" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:t-y-DJ2qbGoLU4Mn" -j cali-pro-kns.calico-system
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:d94BgB3fi5xx9uln" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:-JNo5iqUO6WKTNap" -j cali-pro-_nzzjLvInId1gPHmQz_
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:XJmeOUGuW6xBeI8m" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali55f439ddb0e -m comment --comment "cali:KwviuMJiUXi-jVHG" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:Svp_OJ4-NFXj_B8K" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:nyQj9UO25NH8L91w" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:RYrRXYPy-bhkqZ-v" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-cali9d7310e16e7 -p udp -m comment --comment "cali:244AYDVC8bA30rX3" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-cali9d7310e16e7 -p ipencap -m comment --comment "cali:adfSwi8QUHxkHNtG" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:8ADQ8Jzsc-6WWcVp" -m comment --comment "Start of policies" -j MARK --set-xmark 0x0/0x20000
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:ONY2yOu2M6VeLD-L" -m mark --mark 0x0/0x20000 -j cali-po-_j5sVgQTfF-APgMw0kN9
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:mkYWmkL7qJzTAXcD" -m comment --comment "Return if policy accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:tO374XarJJbFkIdj" -m mark --mark 0x0/0x20000 -j cali-po-_rWDSk9LLgWIl_lpnJE2
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:Vlfk-qZzqVB0aHTn" -m comment --comment "Return if policy accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:d8bepK0owvYXNWJy" -m comment --comment "Drop if no policies passed packet" -m mark --mark 0x0/0x20000 -j DROP
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:F3NrglzuI76G0nM_" -j cali-pro-kns.kube-system
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:YqHk_-9O3SuoCVZ4" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:LcVVg5nKr902xohB" -j cali-pro-_b-WIgmNvlBH1FuEYm2
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:Zs4cI2CEM04i7uaR" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-cali9d7310e16e7 -m comment --comment "cali:_Ab2B_z60B_QKCV-" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:l88DLBgKIHO2A8Oz" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:YiXsvP1sFVWq5mMp" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:xEBLje02fSjGmFFx" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-calic5a1f1aa0ed -p udp -m comment --comment "cali:f4koxmT0fdlBwTvr" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-calic5a1f1aa0ed -p ipencap -m comment --comment "cali:iMenN63JLkiYtYkf" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:6q8jO9xhkfLzCiJb" -j cali-pro-kns.kube-system
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:FicT826c1L5dCy4R" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:nVZixb3gbi9VGe_H" -j cali-pro-_CVSZITRyIpEmH8AB6H
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:xRG27xAnAvjOdSkB" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calic5a1f1aa0ed -m comment --comment "cali:LduFd5odyAkea-Yr" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-fw-calif6abb148530 -m comment --comment "cali:Y5kFLJ6eUqhTTB6Y" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-fw-calif6abb148530 -m comment --comment "cali:TYuydir2GN8MAwZE" -m conntrack --ctstate INVALID -j DROP
-A cali-fw-calif6abb148530 -m comment --comment "cali:nz1b90HObR-grkLR" -j MARK --set-xmark 0x0/0x10000
-A cali-fw-calif6abb148530 -p udp -m comment --comment "cali:v41rYGrJBj1xY2-G" -m comment --comment "Drop VXLAN encapped packets originating in workloads" -m multiport --dports 4789 -j DROP
-A cali-fw-calif6abb148530 -p ipencap -m comment --comment "cali:LdvWkg0Bcr0NYC9d" -m comment --comment "Drop IPinIP encapped packets originating in workloads" -j DROP
-A cali-fw-calif6abb148530 -m comment --comment "cali:nKVcIbM8LaGALHAN" -m comment --comment "Start of policies" -j MARK --set-xmark 0x0/0x20000
-A cali-fw-calif6abb148530 -m comment --comment "cali:pHedYW5eH-3HQdXh" -m mark --mark 0x0/0x20000 -j cali-po-_j5sVgQTfF-APgMw0kN9
-A cali-fw-calif6abb148530 -m comment --comment "cali:TxLZcSN_FBJU_Dg4" -m comment --comment "Return if policy accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calif6abb148530 -m comment --comment "cali:s1ZOtISznALvxVnA" -m mark --mark 0x0/0x20000 -j cali-po-_rWDSk9LLgWIl_lpnJE2
-A cali-fw-calif6abb148530 -m comment --comment "cali:VmIvCvmNmImuZJEJ" -m comment --comment "Return if policy accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calif6abb148530 -m comment --comment "cali:2LypFF-joZDe-7oe" -m comment --comment "Drop if no policies passed packet" -m mark --mark 0x0/0x20000 -j DROP
-A cali-fw-calif6abb148530 -m comment --comment "cali:NlPOXi35nFW5Lm_h" -j cali-pro-kns.kube-system
-A cali-fw-calif6abb148530 -m comment --comment "cali:jjbE8lM3Cp7UKfvS" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calif6abb148530 -m comment --comment "cali:wE5fd2tAhXgvUqv3" -j cali-pro-_b-WIgmNvlBH1FuEYm2
-A cali-fw-calif6abb148530 -m comment --comment "cali:-ybq_9B7fnOurnWi" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-fw-calif6abb148530 -m comment --comment "cali:iDK9j3m3uFLKJ0J_" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-po-_j5sVgQTfF-APgMw0kN9 -m comment --comment "cali:7z6hujEGudXby9dt" -m comment --comment "Policy aaa-allow-konnectivity-agent egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-po-_j5sVgQTfF-APgMw0kN9 -m comment --comment "cali:NTwkPh-Buls_XiN8" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-po-_rWDSk9LLgWIl_lpnJE2 -m comment --comment "cali:wRBTHOraY7-PMOXd" -m comment --comment "Policy kube-system/knp.default.konnectivity-agent egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-po-_rWDSk9LLgWIl_lpnJE2 -m comment --comment "cali:K0NIAoy4j4QR-b6k" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pri-_CVSZITRyIpEmH8AB6H -m comment --comment "cali:Jm7TmoNoWplOEka1" -m comment --comment "Profile ksa.kube-system.metrics-server ingress"
-A cali-pri-_b-WIgmNvlBH1FuEYm2 -m comment --comment "cali:8ILT25kWcdkY3WEJ" -m comment --comment "Profile ksa.kube-system.konnectivity-agent ingress"
-A cali-pri-_npJ7qTPnQvugDgIE9J -m comment --comment "cali:3Kh9Pwd1Mtw7mvad" -m comment --comment "Profile ksa.kube-system.coredns-autoscaler ingress"
-A cali-pri-_nzzjLvInId1gPHmQz_ -m comment --comment "cali:UQoEf2WCdU0bPTCb" -m comment --comment "Profile ksa.calico-system.calico-kube-controllers ingress"
-A cali-pri-kns.calico-system -m comment --comment "cali:hLANj-OVIyT53h_j" -m comment --comment "Profile kns.calico-system ingress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pri-kns.calico-system -m comment --comment "cali:AHts2xleddEc04Gr" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pri-kns.kube-system -m comment --comment "cali:J1TyxtHWd0qaBGK-" -m comment --comment "Profile kns.kube-system ingress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pri-kns.kube-system -m comment --comment "cali:QIB6k7eEKdIg73Jp" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pro-_CVSZITRyIpEmH8AB6H -m comment --comment "cali:jzJff9OzGIv_OyaY" -m comment --comment "Profile ksa.kube-system.metrics-server egress"
-A cali-pro-_b-WIgmNvlBH1FuEYm2 -m comment --comment "cali:1ij2K89T3-KBfAqT" -m comment --comment "Profile ksa.kube-system.konnectivity-agent egress"
-A cali-pro-_npJ7qTPnQvugDgIE9J -m comment --comment "cali:SuQye0xYdA6vsZI5" -m comment --comment "Profile ksa.kube-system.coredns-autoscaler egress"
-A cali-pro-_nzzjLvInId1gPHmQz_ -m comment --comment "cali:5bHxBXLMkJKgC6dk" -m comment --comment "Profile ksa.calico-system.calico-kube-controllers egress"
-A cali-pro-kns.calico-system -m comment --comment "cali:gWxJzCZXxl31NR0P" -m comment --comment "Profile kns.calico-system egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pro-kns.calico-system -m comment --comment "cali:rHIqpX_kWRu4q0wP" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-pro-kns.kube-system -m comment --comment "cali:tgOR2S8DVHZW3F1M" -m comment --comment "Profile kns.kube-system egress" -j MARK --set-xmark 0x10000/0x10000
-A cali-pro-kns.kube-system -m comment --comment "cali:HVEEtYPJsiGRXCIt" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-to-wl-dispatch -o cali112d888c0c2 -m comment --comment "cali:2HgECeqPiWlvDcYF" -g cali-tw-cali112d888c0c2
-A cali-to-wl-dispatch -o cali26cecacb712 -m comment --comment "cali:qItgN3WleQpIBiyv" -g cali-tw-cali26cecacb712
-A cali-to-wl-dispatch -o cali55f439ddb0e -m comment --comment "cali:_Ru9douyhVpAz36r" -g cali-tw-cali55f439ddb0e
-A cali-to-wl-dispatch -o cali9d7310e16e7 -m comment --comment "cali:D9Su0ifqHghdWNA-" -g cali-tw-cali9d7310e16e7
-A cali-to-wl-dispatch -o calic5a1f1aa0ed -m comment --comment "cali:yXvE2mPsXdk4a0va" -g cali-tw-calic5a1f1aa0ed
-A cali-to-wl-dispatch -o calif6abb148530 -m comment --comment "cali:bHXL9zWxzC6IixEY" -g cali-tw-calif6abb148530
-A cali-to-wl-dispatch -m comment --comment "cali:XGNeZ7jL7MJ6PeId" -m comment --comment "Unknown interface" -j DROP
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:YxaG793HT-1CxTcX" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:6MWAWkG1GPepwS3w" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:eIp1vw91xx2wo3h9" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:K1Och8e13hDKqGqa" -j cali-pri-kns.kube-system
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:DaY0j0z-ccvgA-ec" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:mvAbsTsA6HsCQ9sG" -j cali-pri-_CVSZITRyIpEmH8AB6H
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:Boyr3WCDIS7eKocL" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali112d888c0c2 -m comment --comment "cali:8hG8SflKnG26l5GH" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali26cecacb712 -m comment --comment "cali:lrtyQX2m80SOxCl2" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali26cecacb712 -m comment --comment "cali:NxXaMe9Ob6nX2K4G" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali26cecacb712 -m comment --comment "cali:cGFrX7fcfRpkKCHO" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali26cecacb712 -m comment --comment "cali:WKbYZHKhnqL3eEU_" -j cali-pri-kns.kube-system
-A cali-tw-cali26cecacb712 -m comment --comment "cali:j2SXr8W6dIbkurh_" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali26cecacb712 -m comment --comment "cali:TLxfbsZNXEcBwph5" -j cali-pri-_npJ7qTPnQvugDgIE9J
-A cali-tw-cali26cecacb712 -m comment --comment "cali:_fSP42BYgVftfvNJ" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali26cecacb712 -m comment --comment "cali:MRZzU5o7ldmsCSAL" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:9HweFyAJPIWPUhHt" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:M4pjbarn7RsC1h4k" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:JAj_RM1eKdlPKS5f" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:zNamrFqkYkH_SwnZ" -j cali-pri-kns.calico-system
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:UVQPaRAyF_qJqTyX" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:kRTl819Jk_xMa97-" -j cali-pri-_nzzjLvInId1gPHmQz_
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:5ILXhJ0s8TX2LppE" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali55f439ddb0e -m comment --comment "cali:wtGadMzfbnTRvIOE" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:giGy8IjUx3x9IrHo" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:NCOw-jnzdyOQq61d" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:-Sq7uOT3bnaro7xK" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:e3LiLre4KJjf5d7R" -j cali-pri-kns.kube-system
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:yponrdtiVNL9_bvP" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:m837tT1JB6emkdK8" -j cali-pri-_b-WIgmNvlBH1FuEYm2
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:vgog3VPaybOyysLV" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-cali9d7310e16e7 -m comment --comment "cali:agMswGjX-3gKEcHE" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:0FladEynM_2MraTb" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:IHTOdmKjouNNQlaR" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:YeB6y5cFOmDTRuk-" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:pC5hwji0VK5vJnix" -j cali-pri-kns.kube-system
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:3qMYwSyQxYSt22Dg" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:axNsazCIRsKvubPk" -j cali-pri-_CVSZITRyIpEmH8AB6H
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:baIynSfbE77sTGzn" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calic5a1f1aa0ed -m comment --comment "cali:bjIaqKnLZHNVcmXz" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-tw-calif6abb148530 -m comment --comment "cali:1ZCRtbM7qbPTYOCk" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A cali-tw-calif6abb148530 -m comment --comment "cali:zaiHxCx3v71wQVdJ" -m conntrack --ctstate INVALID -j DROP
-A cali-tw-calif6abb148530 -m comment --comment "cali:fefVIb6fLITKcabF" -j MARK --set-xmark 0x0/0x10000
-A cali-tw-calif6abb148530 -m comment --comment "cali:wLX4rAWbg3wnblFL" -j cali-pri-kns.kube-system
-A cali-tw-calif6abb148530 -m comment --comment "cali:GwbopAux4qwslWVb" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calif6abb148530 -m comment --comment "cali:7bHGGHvbebjF5KHB" -j cali-pri-_b-WIgmNvlBH1FuEYm2
-A cali-tw-calif6abb148530 -m comment --comment "cali:Gdqm2gy839GPx6Rc" -m comment --comment "Return if profile accepted" -m mark --mark 0x10000/0x10000 -j RETURN
-A cali-tw-calif6abb148530 -m comment --comment "cali:hNtPYsqgNLJo2cfJ" -m comment --comment "Drop if no profiles matched" -j DROP
-A cali-wl-to-host -m comment --comment "cali:Ee9Sbo10IpVujdIY" -j cali-from-wl-dispatch
-A cali-wl-to-host -m comment --comment "cali:nSZbcOoG1xPONxb8" -m comment --comment "Configured DefaultEndpointToHostAction" -j ACCEPT
```