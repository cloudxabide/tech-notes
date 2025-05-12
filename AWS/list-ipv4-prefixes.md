# How to list IPv4 Prefixes allocated to each ENI?

```
aws ec2 describe-network-interfaces --network-interface-ids eni-0f033157f5c799381 | grep Ipv4Prefix
```