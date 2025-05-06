# Helm list command to display the agents installed on the kubernetes cluster

```
helm ls -A
```

```
NAME                            	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART                                                                    	APP VERSION
aks-managed-overlay-upgrade-data	kube-system	2500    	2025-04-09 04:51:01.840202192 +0000 UTC	deployed	overlay-upgrade-data-addon-0.1.0-3306ac2d69cd70a5d127324597f7996aab68115b
cilium                          	kube-system	166     	2025-04-09 04:50:26.408136978 +0000 UTC	deployed	cilium-addon-0.1.0-49890c7b46f2054d87a586df4fa5b2dc6e99afed
```