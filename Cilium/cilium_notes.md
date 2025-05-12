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

### Is there a way to connect hubble client to a hubble server running on a cilium agent (as opposed to hubble relay)?
```
kubectl -n kube-system exec $CILIUM_POD -- hubble observe
```

### Gateway API and Annotations
- Gateway api controller passes those annotations from `spec.infrastructure` to k8 service annotations and then AWS LB controller creates an NLB accordingly.

### ENI IPAM and Delegated IPAM

- Basically, with ENI and Azure (“legacy”) IPAM there is an IPAM subsystem within Cilium-Agent. The Cilium CNI plugin, whenever a pod is scheduled, then just asks the agent for IPs. The allocation for daemon-owned IPs (cilium_host aka router, cilium-health and ingress) that do not go through the CNI plugin also happens to ask the internal IPAM allocator.

- With delegated IPAM however, the IPAM allocator lives outside of Cilium-Agent. For the CNI plugin, that means it delegates IPAM allocation to a different plugin (very similar to CNI chaining) instead of asking cilium-agent. For agent-owned IPs however this is not something we currently can do, i.e. there is no code in the agent to ask the delegated plugin for an IP. This is why we don’t support the ingress IP (nor cilium-health for that matter) with delegated IPAM, and why the user has to manually specify the cilium_host IP.