# Kubernetes Without Magic [![Build Status](https://travis-ci.org/tkellen/kwm.svg?branch=master)](https://travis-ci.org/tkellen/kwm)
> A glorified shell script generator and text-based adventure game.

## Introduction
This project aims to be a self-guided learning tool and solution for automating
the creation and maintenance of Kubernetes clusters. It is a glorified shell
script generator and text-based adventure game. Though you can use it to start
a cluster with a single command, new operators are encouraged to examine and
execute each step individually until the overall process is understood.

"Without Magic" refers to a design goal of supporting introspection and overall
simplicity as a core tenant. This project is built using two reliable tools that
operators have been using for 40 years: environment variables and shell scripts.

> Learning to use KWM should be possible by running KWM itself. This is very
> much a work in progress. If you try and find yourself stuck, please open an
> issue.

## Getting Started
First, install [kubectl], you'll need that to interact with your cluster once it
is running. Then, choose your flavor of KWM. There are two release types:
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

### B.Y.O.S.
Care has been taken to make as few assumptions about your infrastructure as
possible. This project expects that you will "bring your own servers", and that
they will use systemd. If you satisfy that requirement, this tool should work
equally well for target environments in the cloud, on premises, using VMs,
containers, or bare metal machines. This is an intentional design decision meant
to eliminate reliance on vendor-specific functionality.

### Why?
[This work began as a study on how to run my own cluster]. As a consummate DIYer
this involved me writing an installer. I didn't intend to keep using it, I just
wanted to get the concepts down. After something like one hundred hours of
reading documentation and debugging, I got to a place where spinning up a
cluster seemed easy. I was ready to start using Kubernetes as the foundational
piece of infrastructure in my work. Neat!

As I looked at the installer ecosystem (full of awesome, ambitious projects),
the shell script I'd written started to look pretty appealing. It turns out the
creation of a one-size-fits-all solution for managing a system as configurable
as Kubernetes is quite a challenge.

It is practically inevitable, based on what I've seen, (with this technology and
many others) that we wind up with high level, tool-specific configuration files
aimed at hiding the complexity of the systems we manage. That's the whole point,
right? Make the thing easier.

Then, when we want to go "off script" we plug the holes with yet more indirect
configuration: new command line flags to configure our actual command line flags
and more. This isn't news. This is how computing works—it's a mind-blowing stack
of abstractions.

When I realized I had everything I needed in my humble shell script, I decided
I didn't want more abstractions for this job. So, I wrapped it in a command line
interface aimed at self-learning and joining the ranks of folks trying to tame
this madness.

So far, it's working well. If you try it, I hope it lowers the barrier of entry
to running your own cluster.

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
