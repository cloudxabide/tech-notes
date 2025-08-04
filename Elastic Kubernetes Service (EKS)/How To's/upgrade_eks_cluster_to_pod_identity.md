# How to upgrade an EKS cluster to pod-identity?
## What is EKS Pod-Identity?
- AWS EKS has introduced a new enhanced mechanism called Pod Identity Association for cluster administrators to configure Kubernetes applications to receive IAM permissions required to connect with AWS services outside of the cluster.
- An existing EKS cluster can be upgraded to pod-identity association via
```
eksctl utils migrate-to-pod-identity --cluster cluster2 --approve
2025-05-22 18:39:56 [ℹ]  found IAM role for service account aws-node associated with EKS addon vpc-cni
2025-05-22 18:39:56 [ℹ]  will migrate addon vpc-cni with serviceAccountRoleARN "arn:aws:iam::##############:role/eksctl-cluster2-addon-vpc-cni-Role1-##############" to pod identity; OIDC provider trust relationship will also be removed
2025-05-22 18:39:56 [ℹ]  will migrate 2 iamserviceaccount(s) and 1 addon(s) to pod identity by executing the following tasks
2025-05-22 18:39:56 [ℹ]
2 sequential tasks: { install eks-pod-identity-agent addon,
    2 sequential sub-tasks: {
        update trust policy for owned role "eksctl-cluster2-addon-vpc-cni-Role1-##############",
        migrate addon vpc-cni to pod identity,
    }
}
2025-05-22 18:39:57 [ℹ]  creating addon: eks-pod-identity-agent
2025-05-22 18:40:50 [ℹ]  addon "eks-pod-identity-agent" active
2025-05-22 18:40:51 [ℹ]  updating IAM resources stack "eksctl-cluster2-addon-vpc-cni" for role "eksctl-cluster2-addon-vpc-cni-Role1-##############"
2025-05-22 18:40:51 [ℹ]  waiting for CloudFormation changeset "eksctl-eksctl-cluster2-addon-vpc-cni-Role1-##############-update-##############" for stack "eksctl-cluster2-addon-vpc-cni"
2025-05-22 18:41:22 [ℹ]  waiting for CloudFormation changeset "eksctl-eksctl-cluster2-addon-vpc-cni-Role1-##############-update-##############" for stack "eksctl-cluster2-addon-vpc-cni"
2025-05-22 18:41:22 [ℹ]  waiting for CloudFormation stack "eksctl-cluster2-addon-vpc-cni"
2025-05-22 18:41:53 [ℹ]  waiting for CloudFormation stack "eksctl-cluster2-addon-vpc-cni"
2025-05-22 18:41:53 [ℹ]  updated IAM resources stack "eksctl-cluster2-addon-vpc-cni" for role "eksctl-cluster2-addon-vpc-cni-Role1-##############"
2025-05-22 18:41:53 [ℹ]  creating a pod identity for addon vpc-cni with service account aws-node
2025-05-22 18:41:58 [ℹ]  all tasks were completed successfully
```
- Check that the add-on for pod-identity-agent has been created
```
kubectl get pods -o wide -A
NAMESPACE     NAME                              READY   STATUS    RESTARTS   AGE   IP                NODE                                                NOMINATED NODE   READINESS GATES
kube-system   cilium-7k45k                      1/1     Running   0          25m   192.168.179.8     ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   cilium-operator-cf95c8d69-p2qdn   1/1     Running   0          25m   192.168.154.51    ip-192-168-154-51.ap-northeast-2.compute.internal   <none>           <none>
kube-system   cilium-operator-cf95c8d69-qx7hj   1/1     Running   0          25m   192.168.179.8     ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   cilium-wfffx                      1/1     Running   0          25m   192.168.154.51    ip-192-168-154-51.ap-northeast-2.compute.internal   <none>           <none>
kube-system   coredns-5b9dfbf96-f67zc           1/1     Running   0          37m   192.168.183.228   ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   coredns-5b9dfbf96-hfn6h           1/1     Running   0          37m   192.168.186.127   ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   eks-pod-identity-agent-8nbxz      1/1     Running   0          30m   192.168.179.8     ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   eks-pod-identity-agent-rxbk9      1/1     Running   0          30m   192.168.154.51    ip-192-168-154-51.ap-northeast-2.compute.internal   <none>           <none>
kube-system   kube-proxy-dbvfm                  1/1     Running   0          34m   192.168.179.8     ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   kube-proxy-z4s4g                  1/1     Running   0          34m   192.168.154.51    ip-192-168-154-51.ap-northeast-2.compute.internal   <none>           <none>
kube-system   metrics-server-69695b6bc-8k49r    1/1     Running   0          37m   192.168.175.103   ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
kube-system   metrics-server-69695b6bc-94bt5    1/1     Running   0          37m   192.168.166.8     ip-192-168-179-8.ap-northeast-2.compute.internal    <none>           <none>
```