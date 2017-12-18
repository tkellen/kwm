# KWM on Scaleway

## Setup
1. `export SCALEWAY_ORGANIZATION=<your scaleway org id>`
2. `export SCALEWAY_TOKEN=<your scaleway token>`
3. `terraform init`
4. `terraform apply`
5. `./generate-settings > ../../settings`
6. `cd ../..`
7. `source settings`
8. `./kwm`
9. Follow the prompts.

## Notes
cri-containerd doesn't run.
https://github.com/kubernetes-incubator/cri-containerd/issues/509
