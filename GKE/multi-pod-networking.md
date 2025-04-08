# How to create a GKE cluster that supports multi-pod networking using gcloud?

```
gcloud container clusters create test-gke \
    --cluster-version=1.31 \
    --enable-dataplane-v2 \
    --enable-ip-alias \
    --enable-multi-networking
```