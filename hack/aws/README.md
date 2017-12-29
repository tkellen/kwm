# KWM on AWS

## Setup

1. `export AWS_PROFILE=<your profile name>`
2. `terraform init`
3. `terraform apply && terraform apply` (double apply to ensure eip is set)
4. `./generate-settings > settings`
5. `. ./settings`
8. `kwm`
9. Follow the prompts.

## Notes
Everything works!
