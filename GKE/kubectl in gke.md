# GKE kubectl changes
Once you install kubectl in GKE its imperative that this plugin is installed as well. This new binary, gke-gcloud-auth-plugin, uses [Kubernetes Client-go Credential Plugin](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins) mechanism to extend kubectl’s authentication to support GKE.

```
 apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```