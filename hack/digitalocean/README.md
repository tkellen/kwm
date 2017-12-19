# KWM on Digital Ocean

## Setup
1. `export DIGITALOCEAN_TOKEN=<your token>`
2. `terraform init`
3. `terraform apply`
4. `./generate-settings > ../../settings`
5. `cd ../..`
6. `source settings`
7. `./kwm`
8. Follow the prompts.

## Notes
Cross-node pod-to-pod communication without an overlay network is not yet
supported. Packets with a source address not matching the IP of the Droplet
are black-holed (see DigitalOcean reply below).

Routes on node-0:
```
root@digitalocean-node-0:/etc/cni/net.d# ip route
default via 165.227.80.1 dev eth0 onlink
10.10.0.0/16 dev eth0 proto kernel scope link src 10.10.0.6
10.20.0.0/24 dev kube-bridge proto kernel scope link src 10.20.0.1
10.20.1.0/24 via 10.136.79.24 dev eth1 proto 17
10.136.0.0/16 dev eth1 proto kernel scope link src 10.136.77.249
165.227.80.0/20 dev eth0 proto kernel scope link src 165.227.85.248
```

Routes on node-1:
```
root@digitalocean-node-1:~# ip route
default via 165.227.192.1 dev eth0 onlink
10.10.0.0/16 dev eth0 proto kernel scope link src 10.10.0.8
10.20.0.0/24 via 10.136.77.249 dev eth1 proto 17
10.136.0.0/16 dev eth1 proto kernel scope link src 10.136.79.24
165.227.192.0/20 dev eth0 proto kernel scope link src 165.227.192.203
```

Two containerized workloads running on those nodes:
```
❯ k get pods -o wide
NAME READY STATUS RESTARTS AGE IP WORKER
test 1/1 Running 0 1m 10.20.1.3 digitalocean-node-1
test2 1/1 Running 0 57s 10.20.0.4 digitalocean-node-0
```

Pinging from `test` pod on digitalocean-node-1 to `test2`:
```
/ # ip addr show eth0
3: eth0@if8: mtu 1500 qdisc noqueue
link/ether 0a:58:0a:14:01:03 brd ff:ff:ff:ff:ff:ff
inet 10.20.1.3/24 scope global eth0
valid_lft forever preferred_lft forever
inet6 fe80::9800:2cff:fecc:8001/64 scope link
valid_lft forever preferred_lft forever
/ # ping 10.20.0.4
PING 10.20.0.4 (10.20.0.4): 56 data bytes
```

On digitalocean-node-1, traffic passes through kube-bridge into eth1:
```
root@digitalocean-node-1:~# tcpdump -i eth1 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
15:00:27.956938 IP 10.20.1.3 > 10.20.0.4: ICMP echo request, id 2048, seq 36, length 64
15:00:28.957145 IP 10.20.1.3 > 10.20.0.4: ICMP echo request, id 2048, seq 37, length 64
15:00:29.957326 IP 10.20.1.3 > 10.20.0.4: ICMP echo request, id 2048, seq 38, length 64
15:00:30.957451 IP 10.20.1.3 > 10.20.0.4: ICMP echo request, id 2048, seq 39, length 64
```

...but nothing arrives at digitalocean-node-0 on the node it is destined for:
```
root@digitalocean-node-0:/etc/cni/net.d# tcpdump -i eth1 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
```

### Digital Ocean Reply
Thanks for reaching out and sorry to hear you're running into that problem!
While I haven't used Kubernetes specifically - I've played around with Docker
a bit more - from looking through the documentation[1], you would need to set
up an overlay network.

Our network does uses some security features to block traffic with a source
address that doesn't match the Droplet sending the traffic. We are taking the
first steps toward private network isolation between customers in the coming
months (February, most likely), so that could be something to watch out for
over time as we're working on improvements to private network functionality.

If there's anything else that we can help with, feel free to let us know!
