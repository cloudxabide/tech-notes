# Manifests for the medium article I wrote for extending a service using Private Link Service

[Extending a Service using Private Link](https://medium.com/@amitmavgupta/extending-a-service-using-private-link-from-azure-and-securing-it-with-ciliums-network-policy-ae3248281bbd)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sample-app
  labels:
    app: sample-app
spec:
  containers:
  - image: "testacrrepo.azurecr.io/mycustomimage/nginxamit"
    name: sample-app
    ports:
    - containerPort: 8080
      protocol: TCP
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-app-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true" 
spec:
  type: LoadBalancer
  selector:
    app: sample-app
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 8080
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-app-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true" 
    service.beta.kubernetes.io/azure-pls-create: "true"
    service.beta.kubernetes.io/azure-pls-name: sample-app-pls
spec:
  type: LoadBalancer
  selector:
    app: sample-app
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 8080
```