# Azure Route Server General Troubleshooting commands

## How can you check the learned routes in the Azure Route Server?
- Using Azure CLI, you can check the routes that the Azure Route server has learned.

```
az network routeserver peering list-learned-routes --name 'cilium-egress-gw-bgp' --resource-group 'by
ocniars' --routeserver 'myRouteServer'
{
  "RouteServiceRole_IN_0": [
    {
      "asPath": "65516",
      "localAddress": "192.168.8.69",
      "network": "10.100.255.48/32",
      "nextHop": "192.168.8.36",
      "origin": "EBgp",
      "sourcePeer": "192.168.8.36",
      "weight": 32768
    }
  ],
  "RouteServiceRole_IN_1": [
    {
      "asPath": "65516",
      "localAddress": "192.168.8.68",
      "network": "10.100.255.48/32",
      "nextHop": "192.168.8.36",
      "origin": "EBgp",
      "sourcePeer": "192.168.8.36",
      "weight": 32768
    }
  ]
}

az network routeserver peering list-learned-routes --name 'cilium-egress-gw-bgp-1' --resource-group '
byocniars' --routeserver 'myRouteServer'
{
  "RouteServiceRole_IN_0": [
    {
      "asPath": "65516",
      "localAddress": "192.168.8.69",
      "network": "10.100.255.49/32",
      "nextHop": "192.168.8.37",
      "origin": "EBgp",
      "sourcePeer": "192.168.8.37",
      "weight": 32768
    }
  ],
  "RouteServiceRole_IN_1": [
    {
      "asPath": "65516",
      "localAddress": "192.168.8.68",
      "network": "10.100.255.49/32",
      "nextHop": "192.168.8.37",
      "origin": "EBgp",
      "sourcePeer": "192.168.8.37",
      "weight": 32768
    }
  ]
}
```

## How can you check the routes advertised by the Azure Route Server?
- You can use Azure CLI to check the routes that the Azure Route server has advertised (including the application VM in the subnet 192.168.40.0/22).

```
az network routeserver peering list-advertised-routes --name 'cilium-egress-gw-bgp' --resource-group
'byocniars' --routeserver 'myRouteServer'
{
  "RouteServiceRole_IN_0": [
    {
      "asPath": "65515",
      "localAddress": "192.168.8.69",
      "network": "192.168.40.0/22",
      "nextHop": "192.168.8.69",
      "origin": "Igp",
      "weight": 0
    },
    {
      "asPath": "65515",
      "localAddress": "192.168.8.69",
      "network": "192.168.8.0/22",
      "nextHop": "192.168.8.69",
      "origin": "Igp",
      "weight": 0
    }
  ],
  "RouteServiceRole_IN_1": [
    {
      "asPath": "65515",
      "localAddress": "192.168.8.68",
      "network": "192.168.40.0/22",
      "nextHop": "192.168.8.68",
      "origin": "Igp",
      "weight": 0
    },
    {
      "asPath": "65515",
      "localAddress": "192.168.8.68",
      "network": "192.168.8.0/22",
      "nextHop": "192.168.8.68",
      "origin": "Igp",
      "weight": 0
    }
  ]
}

az network routeserver peering list-advertised-routes --name 'cilium-egress-gw-bgp-1' --resource-group 'byocniars' --routeserver 'myRouteServer'
{
  "RouteServiceRole_IN_0": [
    {
      "asPath": "65515",
      "localAddress": "192.168.8.69",
      "network": "192.168.40.0/22",
      "nextHop": "192.168.8.69",
      "origin": "Igp",
      "weight": 0
    },
    {
      "asPath": "65515",
      "localAddress": "192.168.8.69",
      "network": "192.168.8.0/22",
      "nextHop": "192.168.8.69",
      "origin": "Igp",
      "weight": 0
    }
  ],
  "RouteServiceRole_IN_1": [
    {
      "asPath": "65515",
      "localAddress": "192.168.8.68",
      "network": "192.168.40.0/22",
      "nextHop": "192.168.8.68",
      "origin": "Igp",
      "weight": 0
    },
    {
      "asPath": "65515",
      "localAddress": "192.168.8.68",
      "network": "192.168.8.0/22",
      "nextHop": "192.168.8.68",
      "origin": "Igp",
      "weight": 0
    }
  ]
}
```