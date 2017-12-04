# YAKB
> Yet Another Kubernetes Bootstrap

## Description
This is a learning exercise in operationalizing Kubernetes. The goal of this
project is to provide a single-file bootstrap script for configuring a HA
Kubernetes cluster that can hopefully be used in any hosting environment.

## Setup
1. Clone this repository.
2. Install `kubectl`.
3. Copy `settings.example` to `settings` and fill it out.
4. Run `./bootstrap`.

### Verification
Run `kubectl get componentstatuses`

### TODO
1. Figure out how to run kube-dns.
2. Front the whole thing with [Traefik].

### Future goals
It would be cool to incorporate [Bootkube]-like capabilities (running Kubernetes
in Kubernetes) without using [Bootkube] itself.

### Acknowledgements
https://github.com/kelseyhightower/kubernetes-the-hard-way
https://nixaid.com/deploying-kubernetes-cluster-from-scratch/
https://github.com/kahkhang/kube-linode

[Bootkube]: https://github.com/kubernetes-incubator/bootkube
[Traefik]: https://github.com/containous/traefik
