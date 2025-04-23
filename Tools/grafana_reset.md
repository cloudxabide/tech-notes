- To reset Grafana password

```
#docker exec -it <name of grafana container> grafana-cli admin reset-admin-password <fill in password>
```
- To find the password for grafana

```
#kubectl get secret prometheus-grafana -oyaml -n monitoring
apiVersion: v1
data:
  admin-password: c12345678912345678==
  admin-user: Admin@123=
  ldap-toml: ""
kind: Secret
metadata:
  annotations:
    meta.helm.sh/release-name: prometheus
    meta.helm.sh/release-namespace: monitoring
  creationTimestamp: "2024-06-05T14:53:36Z"
  labels:
    app.kubernetes.io/instance: prometheus
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: grafana
    app.kubernetes.io/version: 10.4.1
    helm.sh/chart: grafana-7.3.11
  name: prometheus-grafana
  namespace: monitoring
  resourceVersion: "33280"
  uid: a4bd98c0-f2a1-4d9a-81b6-73d97be25db5
type: Opaque
```