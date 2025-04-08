# How to create a dual stack GKE cluster using gcloud?

A network and subnet should have been created beforehand.

```
gcloud container clusters create tme-dual-stack \
 --enable-ip-alias \
 --stack-type=ipv4-ipv6 \
 --network=tme-dual-stack \
 --region us-west-2 \
subnetwork=tme-dual-stack
```