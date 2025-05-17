# To deploy the Azure Resource Manager based deployment create a deployment and then trigger the deployment.

```
templateFile="{provide-the-path-to-the-template-file}"
az deployment group create \
  --name <deployment-name> \
  --resource-group <resource-group name> \
  --template-file $templateFile
```