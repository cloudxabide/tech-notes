# Places to look at for logs with EKS clusters

- IPAM logs
```
#tail -f /var/log/aws-routed-eni/ipamd.log
```

```
{"level":"debug","ts":"2025-04-09T12:00:14.936Z","caller":"ipamd/ipamd.go:664","msg":"Reconcile existing ENI eni-0a8a63cdd53f9c6bf IP prefixes"}
{"level":"debug","ts":"2025-04-09T12:00:14.936Z","caller":"ipamd/ipamd.go:1407","msg":"Found prefix pool count 0 for eni eni-0a8a63cdd53f9c6bf\n"}
{"level":"debug","ts":"2025-04-09T12:00:14.936Z","caller":"ipamd/ipamd.go:664","msg":"Successfully Reconciled ENI/IP pool"}
{"level":"debug","ts":"2025-04-09T12:00:14.936Z","caller":"ipamd/ipamd.go:1452","msg":"IP pool stats: Total IPs/Prefixes = 9/0, AssignedIPs/CooldownIPs: 0/0, c.maxIPsPerENI = 9"}
{"level":"debug","ts":"2025-04-09T12:00:17.436Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:22.439Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:27.441Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:32.442Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:37.444Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:42.444Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
{"level":"debug","ts":"2025-04-09T12:00:47.444Z","caller":"ipamd/ipamd.go:661","msg":"IP stats - total IPs: 9, assigned IPs: 0, cooldown IPs: 0"}
```

- Kubelet logs
```
#journalctl -u kubelet  >kubelet.log
```