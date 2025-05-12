# How to find the instance ID of an EC2 Instance using AWS CLI?

```
kubectl get nodes -o=custom-columns=NODE:.metadata.name,ARCH:.status.nodeInfo.architecture,OS-Image:.status.nodeInfo.osImage,OS:.status.nodeInfo.operatingSystem,InstanceId:.spec.providerID
```

```
NODE                                                 ARCH    OS-Image                       OS      InstanceId
ip-192-168-124-55.ap-northeast-2.compute.internal    amd64   Amazon Linux 2023.7.20250331   linux   aws:///ap-northeast-2b/i-0452f8062951459a9
ip-192-168-140-130.ap-northeast-2.compute.internal   amd64   Amazon Linux 2023.7.20250331   linux   aws:///ap-northeast-2c/i-014aa14199d9ff3de
```