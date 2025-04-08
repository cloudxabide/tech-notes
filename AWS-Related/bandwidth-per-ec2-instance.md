# How to find BW per EC2 instance type?

- In this case this is being done for instance type `m4` and you can simply change the instance type to see BW support per instance type.

```
aws ec2 describe-instance-types     --filters "Name=instance-type,Values=m4.*"     --query "InstanceTypes[].[InstanceType, NetworkInfo.NetworkPerformance, NetworkInfo.NetworkCards[0]
.BaselineBandwidthInGbps] | sort_by(@,&[2])"     --output table
---------------------------------------
|        DescribeInstanceTypes        |
+--------------+--------------+-------+
|  m4.large    |  Moderate    |  0.45 |
|  m4.xlarge   |  High        |  0.75 |
|  m4.2xlarge  |  High        |  1.0  |
|  m4.4xlarge  |  High        |  2.0  |
|  m4.10xlarge |  10 Gigabit  |  10.0 |
|  m4.16xlarge |  25 Gigabit  |  25.0 |
+--------------+--------------+-------+
```