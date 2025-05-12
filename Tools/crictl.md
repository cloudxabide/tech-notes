# Crictl commands

- crictl is a command-line interface for CRI-compatible container runtimes. You can use it to inspect and debug container runtimes and applications on a Kubernetes node.

```
crictl ps
crictl inspect <container-id>
crictl inspect <container-id> | grep pid
```