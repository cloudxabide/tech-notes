#How to check nodes have been created in which Availability Zone?

```
#kubectl describe nodes | grep -e "Name:" -e "topology.kubernetes.io/zone"
```

```
Name:               aks-azpcoverlay-11010203-vmss000000
                    topology.kubernetes.io/zone=canadacentral-2
Name:               aks-azpcoverlay-11010203-vmss000001
                    topology.kubernetes.io/zone=canadacentral-1
```