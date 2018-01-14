# Kubernetes Without Magic [![Build Status](https://travis-ci.org/tkellen/kwm.svg?branch=master)](https://travis-ci.org/tkellen/kwm)
> it's just a shell script.

## Description
This is a learning exercise in operationalizing Kubernetes.

## Installation / Getting Started
1. Install [kubectl] (to manage the cluster)
2. `wget https://github.com/tkellen/kwm/releases/download/v0.2.0/kwm && chmod +x kwm`
3. Run `./kwm` and follow the prompts.

## Introduction
This project aims to be a self-guided learning tool and powerful solution for
automating the creation and maintenance of production Kubernetes clusters.

"Without Magic" refers to a design goal of supporting introspection and overall
simplicity as a core tenant. This project is built using two simple tools that
operators have relied on for 40 years: environment variables and shell scripts.

### Why?
[This work began as a study on how to run my own cluster]. As a consummate DIYer
this necessarily involved me writing an installer. I didn't intend to keep using
it, I just wanted to get the concepts down. Then I'd pick a "real" solution.

After more than one hundred hours of reading documentation and debugging, I got
to a place where spinning up a cluster seemed easy. I was ready to start using
Kubernetes as the foundational piece of technology in my projects. Neat!

As I looked at the installer ecosystem, the shell script I'd written started to
look pretty appealing. It turns out that creating a one-size-fits-all solution
for installing a system as configurable as Kubernetes is quite a challenge.

It's almost inevitable that tool authors will simplify the configurability of
the system through a leaky abstraction of their own configuration files and
command line flags. That's the whole point. Make the thing easier.

As I dug in, I realized I didn't want any more layers of abstraction. I already
had a shell script that did the job. Everything it did was right there in plain
old bash. If I needed to configure something differently, I'd just change the
script.

So, I wrapped the whole thing in a nice command line interface and joined the
ranks of folks trying to tame this madness.

If you use this in production, feel free to check it into revision control and
change it as you see fit. It's your installer now.

If you use this for learning, I hope you'll be able to understand Kubernetes an
order of magnitude faster than I did.

Enjoy!

### Ideas for Improvements
- Expand built-in workshops for operators with less experience.
- Support [Bootkube]-like functionality.
- Incorporate [k8s-conformance] testing.
- Translate into multiple languages.

### Release Process
1. Update VERSION file to contain the next version.
2. Run `make release`.

### Acknowledgements
Here are some resources I used while building this project:

* [Kubernetes Documentation] (read every single page)
* [Kubernetes the Hard Way]
* [Deploying Kubernetes from Scratch]
* [Kube-Linode]

Thank you to the authors of those projects and guides!

[Bootkube]: https://github.com/kubernetes-incubator/bootkube
[Kubernetes Documentation]: https://kubernetes.io/docs/home/
[Kubernetes the Hard Way]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[Deploying Kubernetes from Scratch]: https://nixaid.com/deploying-kubernetes-cluster-from-scratch/
[Kube-Linode]: https://github.com/kahkhang/kube-linode
[kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[This work began as a study on how to run my own cluster]: https://github.com/tkellen/kwm/blob/master/log/2017-10-30.md
[k8s-conformance]: https://github.com/cncf/k8s-conformance
