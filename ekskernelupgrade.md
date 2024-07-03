
### Upgrade the Kernel version of a node in EKS

## List the versions that are on the EKS node
```
sudo yum versionlock list
```

## Lock and delete the version you want to upgrade from

```
sudo yum versionlock delete kernel-5.10.219-208.866.amzn2.*

Loaded plugins: priorities, update-motd, versionlock
Deleting versionlock for: 0:kernel-5.10.219-208.866.amzn2.*
versionlock deleted: 1
```

## Disable the existing kernel on EKS node

```
sudo amazon-linux-extras disable kernel-5.10
```

## Install the kernel you want to upgrade your EKS node to

```
sudo amazon-linux-extras install kernel-5.15 -y
```
## Verify the installed kernels from the RPM database

```
rpm -qa |grep kernel

kernel-5.10.219-208.866.amzn2.x86_64
kernel-5.15.160-104.158.amzn2.x86_64
kernel-headers-5.10.219-208.866.amzn2.x86_64
kernel-devel-5.10.219-208.866.amzn2.x86_64
```
## Reboot the node

```
sudo reboot
```