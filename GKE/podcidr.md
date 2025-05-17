# How to find a PodCIDR on a GKE cluster using gcloud?
```
gcloud container clusters describe amit-test-12345 --zone=us-west2-a |   grep -e podIpv4Cidr
    podIpv4CidrBlock: 10.124.0.0/14
  podIpv4CidrSize: 24
```