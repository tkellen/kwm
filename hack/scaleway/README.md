# KWM on Scaleway

## Setup
1. `export SCALEWAY_ORGANIZATION=<your scaleway org id>`
2. `export SCALEWAY_TOKEN=<your scaleway token>`
3. `terraform init`
4. `terraform apply`
5. `./generate-settings` (inspect output before using)
6. `. <(kwm unset)` (clear any previous KWM_ values)
7. `. <(./generate-settings)`
8. `kwm startup | bash`

## Notes
cri-containerd doesn't run.
https://github.com/kubernetes-incubator/cri-containerd/issues/509
