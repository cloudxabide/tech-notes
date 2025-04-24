# GKE no Kube-Proxy Removal Manifest for DataPlane V1

- [GKE no Kube-Proxy](https://medium.com/@amitmavgupta/cilium-installing-cilium-in-gke-with-no-kube-proxy-826e84f971b4)

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: node-init-entrypoint
  labels:
    app: node-init
data:
  entrypoint.sh: |
    #!/usr/bin/env bash
    set -euo pipefail
    ROOT_MOUNT_DIR="${ROOT_MOUNT_DIR:-/root}"
    rm -f "${ROOT_MOUNT_DIR}/etc/kubernetes/manifests/kube-proxy.manifest"
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-init-node-initializer
  labels:
    app: node-init
spec:
  selector:
    matchLabels:
      app: node-init
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: node-init
    spec:
      volumes:
        - name: root-mount
          hostPath:
            path: /
        - name: entrypoint
          configMap:
            name: node-init-entrypoint
            defaultMode: 0744
      initContainers:
        - image: ubuntu:18.04
          name: node-initializer
          command: ["/scripts/entrypoint.sh"]
          env:
            - name: ROOT_MOUNT_DIR
              value: /root
          securityContext:
            privileged: true
          volumeMounts:
            - name: root-mount
              mountPath: /root
            - name: entrypoint
              mountPath: /scripts
      containers:
        - image: "gcr.io/google-containers/pause:2.0"
          name: pause
```