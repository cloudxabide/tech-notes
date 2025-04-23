# How to unpatch the AWS Node daemonset that is usually patched while installing another CNI?

```
#kubectl -n kube-system patch ds aws-node -p '{"spec":{"template":{"spec":{"nodeSelector":null}}}}'
```