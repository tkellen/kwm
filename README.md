# Kubernetes Without Magic [![Build Status](https://travis-ci.org/tkellen/kwm.svg?branch=master)](https://travis-ci.org/tkellen/kwm)
> it just generates shell scripts

## Getting Started
First, install [kubectl], you'll need that to interact with your cluster once it
is running. Then, choose your flavor of KWM. There are two types of releases,
"unbundled" and "bundled". The unbundled version is a shell script and a folder
of templates you can modify as you see fit. The bundled version a single file
shell script with all templates inlined as functions.

**Bundled**
```
wget https://github.com/tkellen/kwm/releases/download/v0.2.0/kwm
chmod +x kwm
./kwm
```

**Unbundled**
```
mkdir kwm && cd kwm
wget https://github.com/tkellen/kwm/releases/download/v0.2.0/kwm-unbundled-v0.2.0.tar.gz
tar xzf kwm-unbundled-v0.2.2.tar.gz
./kwm
```

> It is a goal of this project that a new operator will be able to learn how to
> use KWM and deploy a cluster using the command line only (assuming they have
> already created servers). This is a work in progress. If you try this tool and
> find yourself stuck, please open an issue!

## Introduction
This project aims to be a self-guided learning tool and solution for automating
the creation and maintenance of Kubernetes clusters.

"Without Magic" refers to a design goal of supporting introspection and overall
simplicity as a core tenant. This project is built using two simple tools that
operators have relied on for 40 years: environment variables and shell scripts.

### Why?
[This work began as a study on how to run my own cluster]. As a consummate DIYer
this necessarily involved me writing an installer. I didn't intend to keep using
it, I just wanted to get the concepts down.

After something like one hundred hours of reading documentation and debugging, I
got to a place where spinning up a cluster seemed easy. I was ready to start
using Kubernetes as the foundational piece of technology in my projects. Neat!

As I looked at the installer ecosystem (full of awesome, ambitious projects),
the shell script I'd written started to look pretty appealing. It turns out that
creating a one-size-fits-all solution for installing a system as configurable as
Kubernetes is quite a challenge.

It's almost inevitable that tool authors will simplify the configurability of
the system through an abstraction of their own configuration file formats and
command line flags. That's the whole point. Make the thing easier.

As I dug in, I realized I didn't want more layers of abstraction. I'd already
written everything I needed to do to my servers: it was right there in plain old
bash. If I wanted to configure something differently, I'd just change the
script.

So, I wrapped the thing in a command line interface and joined the ranks of
folks trying to tame this madness. So far, it's working well. Give it a try!

### Ideas for Improvements
- Expand built-in workshops for operators with less experience.
- Support [Bootkube]-like functionality.
- Incorporate [k8s-conformance] testing.
- Translate into multiple languages.

### Release Process
1. Update VERSION file to contain the next version.
2. Run `make release`.

### Acknowledgements
Here are some resources I used while building this:

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
