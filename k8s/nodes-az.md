# Describe nodes based on the AZ's

```
kubectl describe nodes | grep -e "Name:" -e "topology.kubernetes.io/zone"
Name:               ip-192-168-149-253.ap-northeast-2.compute.internal
                    topology.kubernetes.io/zone=ap-northeast-2c
Name:               ip-192-168-171-212.ap-northeast-2.compute.internal
                    topology.kubernetes.io/zone=ap-northeast-2a
```