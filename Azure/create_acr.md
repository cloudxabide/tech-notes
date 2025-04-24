# Create Azure Container Registry

- Create a Resource Group
```
#az group create --name repoacr --location eastus
```

- Check if the name is available to create an ACR
```
#az acr check-name --name testacrrepo
```

- Create an ACR
```
# az acr create --resource-group repoacr -l eastus \ --name testacrrepo --sku Basic
```
- Import NGINX image from Docker Hub
```
#az acr import  -n testacrrepo --source docker.io/library/nginx:latest --image nginx:v1
```

- Build a local image
```
#docker build --platform linux/amd64 -t nginxamit . -f Dockerfile
```

- Login to the ACR
```
#az acr login --name testacrrepo.azurecr.io
```

- Tag the image
```
#docker tag nginxamit testacrrepo.azurecr.io/mycustomimage/nginxamit
```

- Push the image to the ACR repo
```
#docker push testacrrepo.azurecr.io/mycustomimage/nginxamit
```

- How to find the resource-id of the ACR repo?
```
#az role assignment list --scope /subscriptions/########################################/resourceGroups/repoacr/providers/Microsoft.ContainerRegistry/registries/testacrrepo -o table
```

- Update the AKS cluster with AcrPull role assignment
```
#az aks update -n byocniacr -g repoacr --attach-acr /subscriptions/#################################/resourceGroups/repoacr/providers/Microsoft.ContainerRegistry/registries/testacrrepo
```
