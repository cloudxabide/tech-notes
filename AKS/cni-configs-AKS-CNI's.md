These are default values when a user brings up an AKS cluster in either of the listed network plugin modes and what the files look like once the AKS cluster has been upgraded to run with Cilium

- **Azure CNI (Default values)- Deprecated**
    
    ```json
    cat 10-azure.conflist
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

- The local listen IP address for NodeLocal DNSCache can be any IP in the 169.254.20.0/16 space or any other IP address that can be guaranteed to not collide with any existing IP. The first 10 IPs in that space are reserved, and across all deployments, I have seen 169.254.20.10 as the DNS IP by all means.

- **Azure CNI (After Upgrade to CEE)**

```cpp
cat 05-cilium.conf
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

- **Azure CNI Overlay (Default values)**
    
    ```json
    cat 15-azure-swift-overlay.conflist
    {
       "cniVersion":"0.3.0",
       "name":"azure",
       "plugins":[
          {
             "type":"azure-vnet",
             "mode":"transparent",
             "executionMode":"v4swift",
             "ipsToRouteViaHost":["169.254.20.10"],
             "ipam":{
                "type":"azure-cns",
                "mode":"v4overlay"
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
    ```
    
- **Azure CNI Overlay (After Upgrade to CEE)**

```cpp
cat /etc/cni/net.d/05-cilium.conf
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

- **Azure CNI (Dynamic IP Allocation)(Default values)**
    
    ```json
    cat 10-azure.conflist
    {
       "cniVersion":"0.3.0",
       "name":"azure",
       "plugins":[
          {
             "type":"azure-vnet",
             "mode":"transparent",
             "executionMode": "v4swift",
             "ipsToRouteViaHost":["169.254.20.10"],
             "ipam":{
                "type":"azure-cns"
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
    ```
    
- **Azure CNI (Dynamic IP Allocation)(After Upgrade to CEE)**

```cpp
cat /etc/cni/net.d/05-cilium.conf
{
  "cniVersion": "0.3.1",
  "name": "cilium",
  "type": "cilium-cni",
  "enable-debug": false,
  "log-file": "/var/run/cilium/cilium-cni.log"
}
```

- **Bring your own CNI ( Default has no CNI, and once Cilium is installed, these are the contents of the file)**
    
    ```jsx
    cat 05-cilium.conf
    {
      "cniVersion": "0.3.1",
      "name": "cilium",
      "type": "cilium-cni",
      "enable-debug": false,
      "log-file": "/var/run/cilium/cilium-cni.log"
    }
    ```
    
- **Azure CNI powered by Cilium (Default is Cilium)**
    
    ```jsx
    cat 05-cilium.conflist
    {
        "cniVersion": "0.3.1",
        "name": "cilium",
        "plugins": [
            {
                "type": "cilium-cni",
                "ipam": {
                    "type": "azure-ipam"
                },
                "enable-debug": true,
                "log-file": "/var/log/cilium-cni.log"
            }
        ]
    ```
    
- **Kubenet (Default is host-local)**
    
    ```jsx
    cat /etc/cni/net.d/10-containerd-net.conflist
    
    {
        "cniVersion": "0.3.1",
        "name": "kubenet",
        "plugins": [{
        "type": "bridge",
        "bridge": "cbr0",
        "mtu": 1500,
        "addIf": "eth0",
        "isGateway": true,
        "ipMasq": false,
        "promiscMode": true,
        "hairpinMode": false,
        "ipam": {
            "type": "host-local",
            "ranges": [[{"subnet": "10.10.1.0/24"}]],
            "routes": [{"dst": "0.0.0.0/0"}]
        }
        },
        {
        "type": "portmap",
        "capabilities": {"portMappings": true},
        "externalSetMarkChain": "KUBE-MARK-MASQ"
        }]
    }
    ```
    
    - **Isovalent Enterprise for Cilium in Azure Marketplace (Default is Cilium running as a “delegated plugin”)**
    
    ```cpp
    root@aks-default-51761898-vmss000000:/# cat /etc/cni/net.d/05-cilium.conflist
    {
        "cniVersion": "0.3.1",
        "name": "cilium",
        "plugins": [
            {
                "type": "cilium-cni",
                "ipam": {
                    "type": "azure-ipam"
                },
                "enable-debug": true,
                "log-file": "/var/log/cilium-cni.log"
            }
        ]
    ```