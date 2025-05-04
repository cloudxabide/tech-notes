# How to Retrieve region from ec2-metadata

```
#ec2-metadata --availability-zone | awk '{print substr($2, 1, length($2)-1)}''

#sudo bash -c "echo $(ec2-metadata --availability-zone | awk '{print substr($2, 1, length($2)-1)}')"

#sudo bash -c "echo $(ec2-metadata --availability-zone | awk '{print substr($2, 1, length($2)-1)}') > /etc/tetragon/tetragon.conf.d/aws-sonar-region"

#root@ip-172-31-15-63:/etc/tetragon# TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    56  100    56    0     0  11119      0 --:--:-- --:--:-- --:--:-- 11200
root@ip-172-31-15-63:/etc/tetragon# curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document
{
  "accountId" : "###############",
  "architecture" : "x86_64",
  "availabilityZone" : "ap-northeast-2a",
  "billingProducts" : null,
  "devpayProductCodes" : null,
  "marketplaceProductCodes" : null,
  "imageId" : "ami-#################",
  "instanceId" : "i-06b751d334fb71262",
  "instanceType" : "t3.medium",
  "kernelId" : null,
  "pendingTime" : "2025-01-21T05:46:25Z",
  "privateIp" : "172.31.15.63",
  "ramdiskId" : null,
  "region" : "ap-northeast-2",
  "version" : "2017-09-30"
}
```