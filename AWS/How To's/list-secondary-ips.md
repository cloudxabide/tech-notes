# How to list the secondary IPv4 addresses that have been allocated to each node in the nodegroup?

```
aws ec2 describe-instances --instance-ids i-095018359fe01e168 | jq -r '.Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress'
```