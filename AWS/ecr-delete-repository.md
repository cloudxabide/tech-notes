# How to delete an ECR repository?

```
aws ecr delete-repository \
    --repository-name ubuntu \
    --force
```