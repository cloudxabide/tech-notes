# How to enable autoscaling on an EKS cluster?

- Ensure that `coredns` is running as an add-on.
```
aws eks describe-addon --cluster-name cluster1 --addon-name coredns --query addon.addonVersion --output text
```
- The minimum EKS add-on version can be verified by checking this matrix for the respective Kubernetes version the EKS cluster is on. [coredns-autoscaling-kubernetes-matrix](https://docs.aws.amazon.com/eks/latest/userguide/coredns-autoscaling.html)

- Ensure that a current deployment of `coredns` is running
```
kubectl describe deployment coredns --namespace kube-system | grep coredns: | cut -d : -f 3
```
- Update the `coredns` plugin with `autoscaling`
```
aws eks update-addon --cluster-name cluster1 --addon-name coredns \
    --resolve-conflicts PRESERVE --configuration-values '{"autoScaling":{"enabled":true}}'
```
```
{
    "update": {
        "id": "#############################",
        "status": "InProgress",
        "type": "AddonUpdate",
        "params": [
            {
                "type": "ResolveConflicts",
                "value": "PRESERVE"
            },
            {
                "type": "ConfigurationValues",
                "value": "{\"autoScaling\":{\"enabled\":true}}"
            }
        ],
        "createdAt": "2025-05-19T10:31:39.758000+05:30",
        "errors": []
    }
}
```
- Check the status of the `coredns` plugin
```
kubectl rollout status deployment/coredns --namespace kube-system
deployment "coredns" successfully rolled out
```
```
aws eks describe-addon --cluster-name cluster1 --addon-name coredns
{
    "addon": {
        "addonName": "coredns",
        "clusterName": "cluster1",
        "status": "ACTIVE",
        "addonVersion": "v1.11.4-eksbuild.10",
        "health": {
            "issues": []
        },
        "addonArn": "arn:aws:eks:ap-northeast-2:##########################:addon/cluster1/coredns/#################################",
        "createdAt": "2025-05-19T10:11:25.151000+05:30",
        "modifiedAt": "2025-05-19T10:31:46.756000+05:30",
        "tags": {},
        "configurationValues": "{\"autoScaling\":{\"enabled\":true}}",
        "podIdentityAssociations": []
    }
}
```
