# KWM on AWS

## Setup

1. `export AWS_PROFILE=<your profile name>`
2. `terraform init`
3. `terraform apply && terraform apply` (double apply to ensure eip is set)
4. `./generate-settings` (inspect output before using)
5. `. <(kwm unset)` (clear any previous KWM_ values)
6. `. <(./generate-settings)`
7. `kwm start | bash`

## Notes
Everything works!
