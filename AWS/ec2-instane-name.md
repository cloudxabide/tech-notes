# How to find the instance name of an EC2 Instance using AWS CLI?

```
#kaws ec2 describe-instances --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}”, --filters "Name=instance-state-name,Values=running" --output table
```

```
------------------------------------------
|            DescribeInstances           |
+----------------------------+-----------+
|            Name            |  Status   |
+----------------------------+-----------+
|  cluster2-ng-1-Node        |  running  |
|  cluster2-ng-e17b91c9-Node |  running  |
|  cluster2-ng-1-Node        |  running  |
|  cluster2-ng-e17b91c9-Node |  running  |
+----------------------------+-----------+
```