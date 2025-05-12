# How to detach IAM policy from an IAM role?

```
aws iam detach-role-policy --role-name "testrole" --policy-arn "arn:aws:iam::aws:policy/testpolicy"
```