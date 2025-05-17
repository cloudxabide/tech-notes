# How to create an EKS cluster with Bottlerocket as the AMI?

### Pre-Requisites
- [AWS SSM CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-macos-overview.html)
- [Create AWS Key Pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)

### Create a cluster-config file

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: br-cluster
  region: ap-northeast-2

managedNodeGroups:
- name: bottlerocket-nodegroup
  iam:
     attachPolicyARNs:
       - arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
       - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
       - arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
       - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  amiFamily: Bottlerocket
  desiredCapacity: 2
  ssh:
    allow: true
    publicKeyName: amit-seoul
  # taint nodes so that application pods are
  # not scheduled/executed until Cilium is deployed.
  # Alternatively, see the note below.
  taints:
   - key: "node.cilium.io/agent-not-ready"
     value: "true"
     effect: "NoExecute"
```
### Create the cluster

```
#eksctl create cluster -f cluster-config.yaml -v 5
```

### Check the status of the nodes

```
#kubectl get nodes -o wide
NAME                                                STATUS   ROLES    AGE   VERSION               INTERNAL-IP      EXTERNAL-IP      OS-IMAGE                                KERNEL-VERSION   CONTAINER-RUNTIME
ip-192-168-13-142.ap-northeast-2.compute.internal   Ready    <none>   15h   v1.32.2-eks-677bac1   192.168.13.142   43.203.219.209   Bottlerocket OS 1.36.0 (aws-k8s-1.32)   6.1.131          containerd://1.7.27+bottlerocket
ip-192-168-85-112.ap-northeast-2.compute.internal   Ready    <none>   15h   v1.32.2-eks-677bac1   192.168.85.112   15.165.36.60     Bottlerocket OS 1.36.0 (aws-k8s-1.32)   6.1.131          containerd://1.7.27+bottlerocket
```

### Find the instance-ID to login to the nodes

```
#kubectl get nodes -o=custom-columns=NODE:.metadata.name,ARCH:.status.nodeInfo.architecture,OS-Image:.status.nodeInfo.osImage,OS:.status.nodeInfo.operatingSystem,InstanceId:.spec.providerID
NODE                                                ARCH    OS-Image                                OS      InstanceId
ip-192-168-13-142.ap-northeast-2.compute.internal   amd64   Bottlerocket OS 1.36.0 (aws-k8s-1.32)   linux   aws:///ap-northeast-2a/i-0ba500e76635b4290
ip-192-168-85-112.ap-northeast-2.compute.internal   amd64   Bottlerocket OS 1.36.0 (aws-k8s-1.32)   linux   aws:///ap-northeast-2d/i-00f053943da0df3b5
```

### Login to the nodes

```
#aws ssm start-session --target i-0ba500e76635b4290 --region ap-northeast-2
```

### Get access to the admin container

```
[ssm-user@control]$ enter-admin-container
Confirming admin container is enabled...
Waiting for admin container to start...
Entering admin container
          Welcome to Bottlerocket's admin container!
    ╱╲
   ╱┄┄╲   This container provides access to the Bottlerocket host
   │▗▖│   filesystems (see /.bottlerocket/rootfs) and contains common
  ╱│  │╲  tools for inspection and troubleshooting.  It is based on
  │╰╮╭╯│  Amazon Linux 2, and most things are in the same places you
    ╹╹    would find them on an AL2 host.

To permit more intrusive troubleshooting, including actions that mutate the
running state of the Bottlerocket host, we provide a tool called "sheltie"
(`sudo sheltie`).  When run, this tool drops you into a root shell in the
Bottlerocket host's root filesystem.
[root@admin]# sudo sheltie
bash-5.1#
```

### Patch AWS Daemonset

- In case of ENI mode, Cilium will manage ENIs instead of VPC CNI, so the aws-node DaemonSet has to be patched to prevent conflict behavior.

```
#kubectl -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'
```

### Install Cilium as the CNI

```
helm install cilium cilium/cilium --version 1.15 \
  --namespace kube-system \
  --set eni.enabled=true \
  --set ipam.mode=eni \
  --set egressMasqueradeInterfaces=eth0 \
  --set routingMode=native
```