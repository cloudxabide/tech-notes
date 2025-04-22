# Taints in Kubernetes

- Taint a Node
```
#kubectl taint nodes ip-192-168-146-235.ap-northeast-2.compute.internal node.cilium.io/agent-not-ready=true:NoExecute
```

- Untaint a Node
```
#kubectl taint nodes ip-192-168-146-235.ap-northeast-2.compute.internal node.cilium.io/agent-not-ready=true:NoExecute-
```