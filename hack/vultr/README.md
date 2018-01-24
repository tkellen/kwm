# KWM on Vultr

## Setup
1. `go get -u github.com/squat/terraform-provider-vultr`
2. `mkdir -p ~/.terraform.d/plugins/darwin_amd64/`
3. `cp $GOPATH/bin/terraform-provider-vultr ~/.terraform.d/plugins/darwin_amd64`
4. `export VULTR_API_KEY=<your key>`
5. `terraform init`
6. `terraform apply`
7. `./generate-settings` (inspect output before using)
8. `. <(kwm unset)` (clear any previous KWM_ values)
9. `. <(./generate-settings)`
10. `kwm start | bash`

## Notes
Vultr offers private networking but the networks must be configured by the end
user after the machine boots. If I want to give Vultr a shot I need to add some
terraform provisioning scripting to do that after the machines come up. KWM
should not be responsible for that.

Vultr pricing is great... I may come back to this.
