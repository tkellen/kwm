# Kubernetes Without Magic [![Build Status](https://travis-ci.org/tkellen/kwm.svg?branch=master)](https://travis-ci.org/tkellen/kwm)
> A shell script generator.

## Introduction
This project aims to be a self-guided learning tool and solution for automating
the creation and maintenance of Kubernetes clusters. Though you can use it to
start a cluster with a single command, new operators are encouraged to examine
and execute each step individually until the overall process is understood.

"Without Magic" refers to a design goal of supporting introspection and overall
simplicity as a core tenant. This project is built using two reliable tools that
operators have been using for 40 years: environment variables and shell scripts.

> Learning to use KWM should be possible by running KWM itself. This is very
> much a work in progress. If you try and find yourself stuck, please open an
> issue, or better yet, a PR!

## Getting Started
First, install [kubectl], you'll need that to interact with your cluster once it
is running. Then, choose your flavor of KWM. There are two release types:
"unbundled" and "bundled". The unbundled version is a shell script and a folder
of templates you can easily read and modify. The bundled version has all the
templates inlined as functions.

**Bundled**
```
wget https://github.com/tkellen/kwm/releases/download/v0.3.1/kwm
chmod +x kwm
export PATH=$PATH:$PWD
kwm
```

**Unbundled**
```
mkdir kwm && cd kwm
wget https://github.com/tkellen/kwm/releases/download/v0.3.1/kwm-unbundled-v0.3.1.tar.gz
tar xzf kwm-unbundled-v0.3.1.tar.gz
export PATH=$PATH:$PWD
kwm
```

### B.Y.O.S.
Care has been taken to make as few assumptions about your infrastructure as
possible. This project expects that you will "bring your own servers", and that
they will use systemd. If you satisfy that requirement, this tool should work
equally well for target environments in the cloud, on premises, using VMs, test
containers, bare metal machines, you name it. This is an intentional design
decision meant to eliminate reliance on vendor-specific functionality.

## First Time User Guide
This guide illustrates how to use KWM by taking you through the process of
setting up a single-node cluster. It assumes you have KWM installed and in your
PATH.

#### Start your server.
Boot a throwaway server you have SSH and root access to using whatever means is
familiar to you. Make a note of the public and private IPs.

#### Ensure your environment is clean.
KWM accepts configuration solely through environment variables. It includes a
command to remove any previously set values. Ensure you're starting with a
clean slate by running this:
```
. <(kwm unset)
```

#### Export the minimal configuration needed to bootstrap a cluster.
Fill out this configuration. It is OK to use the same IP for public and private
values if you only have one. It's not a great idea for production, though.
```
export KWM_CLUSTER_NAME=kwm
export KWM_APISERVER_PUBLIC_IP=[ip-from-your-only-node]
export KWM_APISERVER_PRIVATE_IP=[ip-from-your-only-node]
export KWM_ROLE_soar="etcd controlplane worker"
export KWM_HOSTNAME_soar=kubernetes-without-magic
export KWM_PRIVATE_IP_soar=[ip-from-your-only-node]
export KWM_CONNECT_soar="ssh [your-sudo-capable-user]@[your-ssh-accessible-ip]"
```

> Try running `kwm define` for more detail about what these values do.

#### Confirm your environment is fully populated for startup.
You should see blue values populating each variable. Some defaults are being
provided by KWM. You can override them if you wish:
```
kwm env startup
```

#### Show what nodes are being managed.
These will all output `soar`. This is searching for `KWM_ROLE_[nodeKey]`
environment variables and filtering on the argument you provide. Because the
example config above defines only one node (with a key of `soar`) that's all
you'll see:
```
kwm nodes all
kwm nodes etcd
kwm nodes controlplane
kwm nodes worker
```

In the future, when you're managing many nodes simultaneously, this will be a
powerful feature for a pipeline of commands.

#### Confirm you can connect to your node:
This will execute the value of environment variable `KWM_CONNECT_[nodeKey]`. If
this is successful you will connect to the server you are about to provision:
```
kwm connect soar
```

#### Provision a single node cluster step by step.
In each command that follows we'll start by having KWM show the commands that
are planned to be run. Your configuration will appear in blue so you can see
what is specific to your installation and what is boilerplate.

First, generate your public key infrastructure to enable secure communication
between your cluster components:
```
kwm render pki
kwm render pki | bash
```

Configure kubectl with administrative access to your cluster-to-be:
```
kwm render cluster-admin
kwm render cluster-admin | bash
```

Configure `soar` as an etcd node:
```
kwm render etcd-node soar
kwm render etcd-node soar | bash
```

Configure `soar` as a controlplane node:
```
kwm render controlplane-node soar
kwm render controlplane-node soar | bash
```

Configure `soar` as a worker node:
```
kwm render worker-node soar
kwm render worker-node soar | bash
```

Configure container networking interface (KWM uses [kube-router] by default):
```
kwm render cni-manifest
kwm render cni-manifest | kubectl --context=kwm apply -f -
```

Restart cri-containerd to pick up CNI settings (TODO: can this be removed?):
> Without restarting cri-containerd after configuring kube-router, pods will
> fail to start with "Failed create pod sandbox".
> https://github.com/containerd/cri-containerd/issues/545  
> https://github.com/cloudnativelabs/kube-router/issues/286  
```
sleep 30
echo "sudo systemctl restart cri-containerd" | kwm connect soar
```

Install kube-dns so your services-to-be can resolve internal DNS:
```
sleep 30
kwm render dns-manifest
kwm render dns-manifest | kubectl --context=kwm apply -f -
```

Congratulations! You should now have a running cluster. It is outside the scope
of this guide to explain how to use `kubectl`, but here are some quick commands
to show its status:
```
kubectl --context=kwm get componentstatus
kubectl --context=kwm get nodes -o wide
kubectl --context=kwm get pods -o wide --all-namespaces
```

As a final note, all of the steps above can be executed for one or many nodes
with this single command:
```
kwm render startup | bash
```

#### Next steps
Try exploring the help system for `kwm`. You can also check out the [hack]
folder in this repository for examples of other configurations. They are not
guaranteed to be working, they are a record of various experiments. Please
contribute your own!

### Ideas for Improvements
- Expand built-in workshops for operators with less experience.
- Support [Bootkube]-like functionality.
- Incorporate [k8s-conformance] testing.
- Translate into multiple languages.

### Release Process
1. Update VERSION file to contain the next version.
2. Run `make release`.

### Why?
[This work began as a study on how to run my own cluster]. As a consummate DIYer
this involved me writing an installer. I didn't intend to keep using it, I just
wanted to get the concepts down. After *many* hours of reading documentation, I
got to a place where spinning up a cluster and debugging myriad of ways it could
fail seemed easy. I was ready to start using Kubernetes as the foundational
piece of infrastructure in my work.

Neat!

As I looked at the installer ecosystem (full of awesome, ambitious projects),
the shell script I'd written started to look pretty appealing. It turns out the
creation of a one-size-fits-all solution for managing a system as configurable
as Kubernetes is quite a challenge.

It is practically inevitable (with this technology and many others) that we wind
up with high level, tool-specific configuration files aimed at hiding the
complexity of the systems we manage. That's the whole point, right? Make the
thing easier.

Then, when we want to go "off script" we plug the holes with yet more indirect
configuration: new command line flags to configure our actual command line flags
and more. This isn't news. This is how computing works—it's a mind-blowing stack
of abstractions.

Eventually, I realized I already had everything I needed in my shell script. I
didn't need much more abstraction. So I wrapped it in a command line interface
aimed at self-learning, and joined the ranks of folks trying to tame this
madness.

So far, it's working well. If you try it, I hope it lowers the barrier of entry
to running your own cluster.

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
[hack]: https://github.com/tkellen/kwm/tree/master/hack
[kube-router]: https://github.com/cloudnativelabs/kube-router
