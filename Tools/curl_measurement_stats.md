# How can you see connect connect times etc with curl? 

- Simply add this to your .bashrc or .zshrc and every time you run curl you will see some interesting stats

```
-w "\n\n==== cURL measurements stats ====\ntotal: %{time_total} seconds \nsize: %{size_download} bytes \ndnslookup: %{time_namelookup} seconds \nconnect: %{time_connect} seconds \nappconnect: %{time_appconnect} seconds \nredirect: %{time_redirect} seconds \npretransfer: %{time_pretransfer} seconds \nstarttransfer: %{time_starttransfer} seconds \ndownloadspeed: %{speed_download} byte/sec \nuploadspeed: %{speed_upload} byte/sec \n\n"
```

```
curl ip.now
2405:201:d01c:509a:e41a:ce4a:d7e1:fe4c

==== cURL measurements stats ====
total: 0.555113 seconds
size: 39 bytes
dnslookup: 0.198472 seconds
connect: 0.348323 seconds
appconnect: 0.000000 seconds
redirect: 0.000000 seconds
pretransfer: 0.348510 seconds
starttransfer: 0.554969 seconds
downloadspeed: 70 byte/sec
uploadspeed: 0 byte/sec
```