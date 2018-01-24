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
10. `terraform apply` (yes, do it twice)
11. `./generate-settings` (inspect output before using)
12. `. <(kwm unset)` (clear any previous KWM_ values)
13. `. <(./generate-settings)`
14. `kwm start | bash`

## Notes
Cross-node pod communication doesn't work.
See notes for digitalocean. Same issue.
