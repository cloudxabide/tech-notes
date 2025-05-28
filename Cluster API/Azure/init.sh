#!/bin/bash

source ./cred.sh

# Azure cloud settings

export AZURE_SUBSCRIPTION_ID_B64="$(echo "$AZURE_SUBSCRIPTION_ID" | base64 | tr -d '\n')"
export AZURE_TENANT_ID_B64="$(echo "$AZURE_TENANT_ID" | base64 | tr -d '\n')"
export AZURE_CLIENT_ID_B64="$(echo "$AZURE_CLIENT_ID" | base64 | tr -d '\n')"
export AZURE_CLIENT_SECRET_B64="$(echo "$AZURE_CLIENT_SECRET" | base64 | tr -d '\n')"

clusterctl init --infrastructure azure

cat <<EOF > azureidentity.yml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureClusterIdentity
metadata:
  name: example-identity
spec:
  type: ServicePrincipal
  tenantID: "$AZURE_TENANT_ID"
  clientID: "$AZURE_CLIENT_ID"
  clientSecret: {"name":"example-identity-secret","namespace":"default"}
  allowedNamespaces:
    list:
    - default
---
apiVersion: v1
kind: Secret
metadata:
  name: example-identity-secret
type: Opaque
data:
  clientSecret: $AZURE_CLIENT_SECRET_B64
EOF

kubectl apply -f azureidentity.yml