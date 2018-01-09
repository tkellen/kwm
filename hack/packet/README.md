# KWM on Packet

## Setup
1. `export PACKET_AUTH_TOKEN=<your token>`
2. `terraform init`
3. `terraform apply`
4. `./generate-settings` (inspect output before using)
5. `. <(kwm unset)`
6. `. <(./generate-settings)`
7. `kwm startup | bash`

## Notes
Everything works!
