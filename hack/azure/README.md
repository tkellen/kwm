# KWM on Azure

## Setup
1. az login
2. az account show
3. `export ARM_TENANT_ID=<tenantId from response above>`
4. `export ARM_SUBSCRIPTION_ID=<id from response above>`
5. `az ad sp create-for-rbac --role="Terraform" --scopes="/subscriptions/$ARM_SUBSCRIPTION_ID"`
   ^ save this output for future runs
6. `export ARM_CLIENT_ID=<appId in response from "az ad sp....">`
7. `export ARM_CLIENT_SECRET=<password in response from "az ad sp....">`
8. `terraform init`
9. `terraform apply`
10. `terraform apply`
11. `./generate-settings > ../../settings`
12. `cd ../..`
13. `source settings`
14. `./kwm`
15. Follow the prompts.


## Notes
cross-node pod communication doesn't work.
sysctl net.ipv4.ip_forward is set to 1
traffic leaving pod destinated for ip of pod on different node passes through
kube-bridge to eth0 but never arrives at destination
static route is present.

not sure how to debug further.
