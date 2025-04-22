# How to find API Server IP and port

- By default, the Kubernetes API server listens on port 6443 on the first non-localhost network interface, protected by TLS. In a typical production Kubernetes cluster, the API serves on port 443. 

## First, create the Secret, requesting a token for the default ServiceAccount:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: default-token
  annotations:
    kubernetes.io/service-account.name: default
type: kubernetes.io/service-account-token
```

## Next, wait for the token controller to populate the Secret with a token:
```
while ! kubectl describe secret default-token | grep -E '^token' >/dev/null; do
  echo "waiting for token..." >&2
  sleep 1
done
```


## Capture and use the generated token:
```
#APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
#TOKEN=$(kubectl describe secret default-token | grep -E '^token' | cut -f2 -d':' | tr -d " ")
#curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
```
- Alternative you can also do 
```
#kubectl proxy --port=8080 &
#curl http://localhost:8080/api/
```

- Alternative you can also do
# Point to the internal API server hostname
```
#APISERVER=https://kubernetes.default.svc
```

# Path to ServiceAccount token
```
#SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
```

# Read this Pod's namespace
```
#NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
```

# Read the ServiceAccount bearer token
```
#TOKEN=$(cat ${SERVICEACCOUNT}/token)
```

# Reference the internal certificate authority (CA)
```
#CACERT=${SERVICEACCOUNT}/ca.crt
```

# Explore the API with TOKEN
```
#curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api
```