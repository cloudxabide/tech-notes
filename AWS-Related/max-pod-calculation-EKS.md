# How to calculate the Maximum Number of pods supported by the Ec2 instance.
- The first IP on each ENI is not used for pods +2 for the pods that use host networking (AWS CNI and kube-proxy)

```
# of ENI * (# of IPv4 per ENI - 1) + 2
```

```
So for m5.large 3*(10-1) +2 = 3*9 + 2= 27 +2= 29
```