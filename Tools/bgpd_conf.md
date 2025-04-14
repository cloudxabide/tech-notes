# Sample bgpd.conf file

```
!
hostname bgpd
password quagga
enable password quagga
!
!bgp mulitple-instance
!
router bgp 1
bgp router-id 10.128.0.14
network 10.128.0.0/20
neighbor 10.128.0.13 remote-as 65000
neighbor 10.128.0.13 ebgp-multihop
!
access-list all permit any
log file bgpd.log
!
log stdout
```