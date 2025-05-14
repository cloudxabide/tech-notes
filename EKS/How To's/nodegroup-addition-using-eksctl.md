# How to add a nodegroup in an EKS cluster using eksctl?
```
eksctl create nodegroup \
    --cluster pd-cluster \ 
    --region us-west-2 \ 
    --name pg-nodegroup \ 
    --node-type m5.large \
    --nodes 1
```