# AKS Identity and Principal ID

- Create an identity 
```
az identity create --name $IDENTITY --resource-group $RESOURCE_GROUP_NAME
```

- Define the PRINCIPAL_ID
```
PRINCIPAL_ID=$(az identity show --name $IDENTITY --resource-group $RESOURCE_GROUP_NAME --query principalId -o tsv)
```