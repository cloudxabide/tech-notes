# Some new clustermesh troubleshooting commands available from Cilium 1.16 Release

- Verify whether Cilium agents are successfully connected to all remote clusters.
```
kubectl exec -n kube-system -ti ds/cilium -- cilium-dbg status --all-clusters
```
- Clustermesh Troubleshooting
```
kubectl exec -n kube-system -ti ds/cilium -- cilium-dbg troubleshoot clustermesh
```

- ClusterMesh affinity
```
kubectl exec -n kube-system -ti ds/cilium -- cilium service list --clustermesh-affinity
```

- Validate Mixed Routing Mode
```
kubectl get ciliumnode -o custom-columns='NAME:.metadata.name,MODES:.metadata.annotations.routing\.isovalent\.com/supported'
```