# kubernetes on digital ocean

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
cross-node pod communication doesn't work.
sysctl net.ipv4.ip_forward is set to 1
traffic passes through kube-bridge to eth1 but never arrives at destination:
static route is present.

is the digitalocean hypervisor dropping packets or do i not know what i'm doing?
https://www.digitalocean.com/community/questions/nat-gateway-on-digital-ocean-s-droplet-possible?answer=13896
not sure how to debug further.
