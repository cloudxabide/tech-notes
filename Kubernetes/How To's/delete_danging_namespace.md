# How to delete a dangling namespace?

```
Error: INSTALLATION FAILED: failed to create resource: roles.rbac.authorization.k8s.io "cilium-ingress-secrets" is forbidden: unable to create new content in namespace cilium-secrets because it is being terminated
```

```
kubectl get ns -A
NAME              STATUS        AGE
cilium-secrets    Terminating   19h
default           Active        19h
kube-node-lease   Active        19h
kube-public       Active        19h
kube-system       Active        19h
```

```
NAMESPACE=cilium-secrets

kubectl proxy &
[1] 4337

Starting to serve on 127.0.0.1:8001

kubectl get namespace $NAMESPACE -o json |jq '.spec = {"finalizers":[]}' >temp.json

rm -rf tmp.json

curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "cilium-secrets",
    "uid": "################################",
    "resourceVersion": "9518",
    "creationTimestamp": "2024-06-05T14:11:43Z",
    "deletionTimestamp": "2024-06-05T14:12:23Z",
    "labels": {
      "app.kubernetes.io/managed-by": "Helm",
      "kubernetes.io/metadata.name": "cilium-secrets"
    },
    "annotations": {
      "meta.helm.sh/release-name": "cilium",
      "meta.helm.sh/release-namespace": "kube-system"
    },
    "managedFields": [
      {
        "manager": "helm",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-06-05T14:11:43Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              ".": {},
              "f:meta.helm.sh/release-name": {},
              "f:meta.helm.sh/release-namespace": {}
            },
            "f:labels": {
              ".": {},
              "f:app.kubernetes.io/managed-by": {},
              "f:kubernetes.io/metadata.name": {}
            }
          }
        }
      },
      {
        "manager": "kube-controller-manager",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-06-05T14:12:28Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:status": {
            "f:conditions": {
              ".": {},
              "k:{\"type\":\"NamespaceContentRemaining\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              },
              "k:{\"type\":\"NamespaceDeletionContentFailure\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              },
              "k:{\"type\":\"NamespaceDeletionDiscoveryFailure\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              },
              "k:{\"type\":\"NamespaceDeletionGroupVersionParsingFailure\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              },
              "k:{\"type\":\"NamespaceFinalizersRemaining\"}": {
                ".": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              }
            }
          }
        },
        "subresource": "status"
      }
    ]
  },
  "spec": {},
  "status": {
    "phase": "Terminating",
    "conditions": [
      {
        "type": "NamespaceDeletionDiscoveryFailure",
        "status": "True",
        "lastTransitionTime": "2024-06-05T14:12:28Z",
        "reason": "DiscoveryFailed",
        "message": "Discovery failed for some groups, 1 failing: unable to retrieve the complete list of server APIs: metrics.k8s.io/v1beta1: stale GroupVersion discovery: metrics.k8s.io/v1beta1"
      },
      {
        "type": "NamespaceDeletionGroupVersionParsingFailure",
        "status": "False",
        "lastTransitionTime": "2024-06-05T14:12:28Z",
        "reason": "ParsedGroupVersions",
        "message": "All legacy kube types successfully parsed"
      },
      {
        "type": "NamespaceDeletionContentFailure",
        "status": "False",
        "lastTransitionTime": "2024-06-05T14:12:28Z",
        "reason": "ContentDeleted",
        "message": "All content successfully deleted, may be waiting on finalization"
      },
      {
        "type": "NamespaceContentRemaining",
        "status": "False",
        "lastTransitionTime": "2024-06-05T14:12:28Z",
        "reason": "ContentRemoved",
        "message": "All content successfully removed"
      },
      {
        "type": "NamespaceFinalizersRemaining",
        "status": "False",
        "lastTransitionTime": "2024-06-05T14:12:28Z",
        "reason": "ContentHasNoFinalizers",
        "message": "All content-preserving finalizers finished"
      }
    ]
  }
}
```
```
kubectl get ns -A
NAME              STATUS   AGE
default           Active   19h
kube-node-lease   Active   19h
kube-public       Active   19h
kube-system       Active   19h
```