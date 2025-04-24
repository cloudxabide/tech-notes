# Cilium Notes

### Envoy
- False runs Envoy in the same Pod as Cilium. True runs it in another Pod, one per node.

```
external-envoy-proxy                              false
```
### Endpoint Routes
- Our Helm charts automatically enable endpoint routes automatically if you use the eni, gke or azure Helm values (e.g. gke.enabled=true, grep for enable-endpoint-routes: "true" in cilium-configmap.yaml).
- On Azure, ENI and AlibabCloud, Cilium-Agent will auto-derive the ipv4-native-routing-cidr (code here), so you don’t have to set it manually. On GKE however, you do have to set it, since we don’t have the code for auto-detection.
- You don’t have to explicitly set endpoint routes, and you only have to explicitly set the native-routing-cidr on GKE.