# How to enable preview Features?

## KataVMIsovalation
```
#az feature register --namespace "Microsoft.ContainerService" --name "KataVMIsolationPreview"
Once the feature 'KataVMIsolationPreview' is registered, invoking 'az provider register -n Microsoft.ContainerService' is required to get the change propagated
{
  "id": "/subscriptions/##############################/providers/Microsoft.Features/providers/Microsoft.ContainerService/features/KataVMIsolationPreview",
  "name": "Microsoft.ContainerService/KataVMIsolationPreview",
  "properties": {
    "state": "Registering"
  },
  "type": "Microsoft.Features/providers/features"
}
```

```
az feature show --namespace "Microsoft.ContainerService" --name "KataVMIsolationPreview" -o table
Name                                               RegistrationState
-------------------------------------------------  -------------------
Microsoft.ContainerService/KataVMIsolationPreview  Registered
```
