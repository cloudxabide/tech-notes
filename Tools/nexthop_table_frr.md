# How to see the next hop table in FRR?

```
sh ip nht
```
```
VRF default:
 Resolve via default: on
10.1.0.4
 resolved via kernel, prefix 0.0.0.0/0
 via 10.0.0.1, eth0 (vrf default), src 10.0.0.4, weight 1
 Client list: bgp(fd 18)
10.1.0.5
 resolved via kernel, prefix 0.0.0.0/0
 via 10.0.0.1, eth0 (vrf default), src 10.0.0.4, weight 1
 Client list: bgp(fd 18)
192.168.121.204
 resolved via connected, prefix 192.168.121.128/25
 is directly connected, virbr1 (vrf default), weight 1
 Client list: bgp(fd 18)
192.168.121.245
 resolved via connected, prefix 192.168.121.128/25
 is directly connected, virbr1 (vrf default), weight 1
 Client list: bgp(fd 18)
```