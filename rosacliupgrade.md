rosacli.md
# How to Upgrade ROSA CLI on your workstation
This is assuming that <[ROSA CLI](https://docs.redhat.com/en/documentation/red_hat_openshift_service_on_aws/4/html/rosa_cli/rosa-get-started-cli#rosa-setting-up-cli_rosa-getting-started-cli)> has been configured already on your workstation.

## List the versions that are on the EKS node

```
#rosa download rosa-client
I: Downloading https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/rosa-linux.tar.gz to your current directory
Downloading... 36 MB complete
I: Successfully downloaded rosa-linux.tar.gz
```

```
#tar xvf rosa-linux.tar.gz
#rosa
#sudo mv rosa /usr/local/bin/rosa
#rosa version
I: 1.2.50
I: Your ROSA CLI is up to date.
```