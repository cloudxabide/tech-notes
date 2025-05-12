# How to run with tunnel protocol or encapsulation as GENEVE with Cilium?

```
helm install cilium cilium/cilium --version 1.17.3 \
  --namespace kube-system \
  --set aksbyocni.enabled=true \
  --set tunnelProtocol=geneve
```