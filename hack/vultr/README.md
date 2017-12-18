# kubernetes on vultr

## Setup
1. `go get -u github.com/squat/terraform-provider-vultr`
2. `mkdir -p ~/.terraform.d/plugins/darwin_amd64/`
3. `cp $GOPATH/bin/terraform-provider-vultr ~/.terraform.d/plugins/darwin_amd64`
4. `export VULTR_API_KEY=<your key>`
5. `terraform init`
6. `terraform apply`
7. `./generate-settings > ../../settings`
7. `source settings`
8. `./kwm`
9. Follow the prompts.

## Notes
Needs additional provisioning scripts to set up private networking.
