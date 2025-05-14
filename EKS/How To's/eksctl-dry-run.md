# Significance of eksctl dry-run command

- The dry-run feature allows you to inspect and change the instances matched by the instance selector before proceeding to creating a nodegroup.

```
eksctl create cluster -f eks-config_ipv4.yaml --dry-run
```

```
accessConfig:
  authenticationMode: API_AND_CONFIG_MAP
addonsConfig: {}
apiVersion: eksctl.io/v1alpha5
availabilityZones:
- ap-southeast-2b
- ap-southeast-2c
- ap-southeast-2a
iam:
  vpcResourceControllerPolicy: true
  withOIDC: false
kind: ClusterConfig
managedNodeGroups:
- amiFamily: AmazonLinux2023
  desiredCapacity: 2
  disableIMDSv1: true
  disablePodIMDS: false
  iam:
    withAddonPolicies:
      albIngress: false
      appMesh: null
      appMeshPreview: null
      autoScaler: false
      awsLoadBalancerController: false
      certManager: false
      cloudWatch: false
      ebs: false
      efs: false
      externalDNS: false
      fsx: false
      imageBuilder: false
      xRay: false
  instanceSelector: {}
  labels:
    alpha.eksctl.io/cluster-name: cluster1
    alpha.eksctl.io/nodegroup-name: ng-1
  maxSize: 2
  minSize: 2
  name: ng-1
  privateNetworking: true
  releaseVersion: ""
  securityGroups:
    withLocal: null
    withShared: null
  ssh:
    allow: false
  tags:
    alpha.eksctl.io/nodegroup-name: ng-1
    alpha.eksctl.io/nodegroup-type: managed
  taints:
  - effect: NoExecute
    key: node.cilium.io/agent-not-ready
    value: "true"
  volumeIOPS: 3000
  volumeSize: 80
  volumeThroughput: 125
  volumeType: gp3
metadata:
  name: cluster1
  region: ap-southeast-2
  version: "1.30"
privateCluster:
  enabled: false
  skipEndpointCreation: false
vpc:
  autoAllocateIPv6: false
  cidr: 192.168.0.0/16
  clusterEndpoints:
    privateAccess: false
    publicAccess: true
  manageSharedNodeSecurityGroupRules: true
  nat:
    gateway: Single
```