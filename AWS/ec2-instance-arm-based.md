# How to find the instance type that supports ARM based architecture

```
aws ec2 describe-instance-types \
  --filters "Name=current-generation,Values=true" \
  "Name=vcpu-info.default-vcpus,Values=2" \
  "Name=memory-info.size-in-mib,Values=4096" \
  "Name=processor-info.supported-architecture,Values=arm64" \
  --query "InstanceTypes[*].InstanceType"
```