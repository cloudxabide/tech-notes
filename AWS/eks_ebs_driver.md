# Steps to enable EBS policy for your cluster nodegroup:
- Go to console>> IAM >> Roles.
- Search for node group name and select it.
- Under permissions, click on Add permissions from the Dropdown.
- Attach policies
- Search for the term ‘EBS’
- Click on ’AmazonEBSCSIDriverPolicy’
- Add permission.

## Install the drivers:
```
#kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

