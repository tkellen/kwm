# make it work everywhere
> does this actually work anywhere? let's try.

### aws
everything works.

### azure
cross-node pod communication doesn't work.
sysctl net.ipv4.ip_forward is set to 1
traffic leaving pod destinated for ip of pod on different node passes through
kube-bridge to eth0 but never arrives at destination
static route is there.

not sure how to debug further.

### digitalocean
cross-node pod communication doesn't work.
sysctl net.ipv4.ip_forward is set to 1
static route is present.
traffic passes through kube-bridge to eth1 but never arrives at destination:
static route is there.

is the digitalocean hypervisor dropping it or do i not know what i'm doing?
https://www.digitalocean.com/community/questions/nat-gateway-on-digital-ocean-s-droplet-possible?answer=13896
not sure how to debug further.

### triton
containerd can't start:
modprobe overlay
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/4.3.0/modules.dep.bin'
modprobe: FATAL: Module overlay not found in directory /lib/modules/4.3.0

### linode
still setting stuff up.

### google
still setting stuff up.
