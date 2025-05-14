# How to run with tunnel protocol or encapsulation as VXLAN or Geneve with Cilium?

- VXLAN

```
helm install cilium cilium/cilium --version 1.17.3 \
  --namespace kube-system \
  --set aksbyocni.enabled=true \
  --set tunnelProtocol=vxlan
```

- GENEVE

```
helm install cilium cilium/cilium --version 1.17.3 \
  --namespace kube-system \
  --set aksbyocni.enabled=true \
  --set tunnelProtocol=geneve
```