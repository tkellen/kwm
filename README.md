# KWM
> Kubernetes Without Magic

## Warning
This is an early stage work in progress. Do not expect anything here to be
stable, yet.

## Description
This is a learning exercise in operationalizing Kubernetes.

## Setup
1. Clone this repository.
2. Install `kubectl` and `jq`.
3. Create a `settings` file (read `settings.example` for guidance).
4. Run `./compile`.
5. Run `cd ./cluster/$KWM_CLUSTER_NAME && ./kwm` to generate your installation files.
6. TBD.

<!--
The goal of this project is to provide a single-file bootstrap script for
configuring a production-ready high availability Kubernetes cluster that can
be used in any hosting environment. It also aims to document the process so
thoroughly that anyone could understand it.

## TODO
1. Front the whole thing with [Traefik].
2. Finish writing docs.

## Setup
1. Clone this repository.
2. Install `kubectl` and `jq`.
3. Create a `settings` file (read `settings.example` for guidance).
4. Run ./compile

## Instructions
KWM can be run in stages so a first-time operator can understand each of
the components and what capabilities it provides.

Before starting, pull in the settings you specified during setup:
```shell
source settings
```

You can now reference any property in your settings file by name. Try this:
```shell
echo $SSH_USER
```

## Public Key Infrastructure
> One line that explains what PKI is for in the context of Kubernetes.

**Build your PKI:**
```shell
./kwm pki
```

TODO: Show commands to validate the output, explaining each item and why it is
required.

### Additional Reading
- TBD
- TBD

## Distributed Key Value Store (etcd)
> One line that explains what etcd is for in the context of Kubernetes.

**Build your etcd cluster:**
```shell
./kwm etcd
```

**Check to see if the cluster bootstrapped successfully:**
```shell
ETCD_HOST=$(echo $ETCD_SSH_IPS | cut -d ',' -f 1)
ssh $SSH_USER@$ETCD_HOST ETCDCTL_API=3 etcdctl member list
```
⤹
```
86edf96310cdff73, started, etcd-1, https://10.100.1.10:2380, https://10.100.1.10:2379
9e42d7788564f684, started, etcd-2, https://10.100.2.10:2380, https://10.100.2.10:2379
c7506878d20491a2, started, etcd-0, https://10.100.0.10:2380, https://10.100.0.10:2379
```

**Confirm you can store data (set the key `test` to the value `hello`):**
```shell
ETCD_HOST=$(echo $ETCD_SSH_IPS | cut -d ',' -f 1)
ssh $SSH_USER@$ETCD_HOST ETCDCTL_API=3 etcdctl put test hello
```
⤹
```
OK
```

**Get the value of the key you just set from the same etcd host:**
```shell
ETCD_HOST=$(echo $ETCD_SSH_IPS | cut -d ',' -f 1)
ssh $SSH_USER@$ETCD_HOST ETCDCTL_API=3 etcdctl get test
```
⤹
```
test
hello
```

**Get the value of the key you just set from a different etcd host:**
```shell
ETCD_HOST=$(echo $ETCD_SSH_IPS | cut -d ',' -f 2)
ssh $SSH_USER@$ETCD_HOST ETCDCTL_API=3 etcdctl get test
```
⤹
```
test
hello
```

### Additional Reading
- TBD
- TBD

## Kubernetes Control Plane
> One line that explains what the Kubernetes Control Plane is for.

**Build your control plane:**
```shell
./kwm control-plane
```

**Check control plane components to ensure they are running:**
```shell
kubectl get componentstatuses
```
⤹
```
NAME                 STATUS    MESSAGE              ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   {"health": "true"}
etcd-1               Healthy   {"health": "true"}
etcd-2               Healthy   {"health": "true"}
```

### Additional Reading
- TBD
- TBD

## Kubernetes Worker Nodes
> One line that explains what Nodes are for.

**Build your nodes:**
```shell
./kwm node
```

**Confirm your Nodes are registered and ready to run Pods:**
```shell
kubectl get nodes
```
⤹
```
NAME     STATUS    ROLES     AGE       VERSION
node-0   Ready     <none>    1h        v1.8.4
node-1   Ready     <none>    1h        v1.8.4
node-2   Ready     <none>    1h        v1.8.4
```

**Run your first Pod and shell into it:**
```shell
kubectl run -it --rm --restart=Never test --image=busybox -- sh
```
⤹
```
If you don't see a command prompt, try pressing enter.
/ # ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
/ # exit
```

### Additional Reading
- TBD
- TBD

## Kubernetes Networking
> One line that explains networking in the context of Kubernetes (ahahaha).

**Start busybox on specific Node:**
```shell
NODE_NAME=$(echo $NODE_NAMES | cut -d ',' -f 1)
kubectl run networktest \
  --image=busybox \
  --overrides="{\"apiVersion\":\"extensions/v1beta1\",\"spec\":{\"template\":{\"spec\":{\"nodeSelector\":{\"kubernetes.io/hostname\":\"${NODE_NAME}\"}}}}}" \
  --command -- sleep 36000
```

**Confirm Pod is running on network testing Node:**
```shell
kubectl get pods -o wide
```
⤹
```
NAME                           READY     STATUS    RESTARTS   AGE       IP           NODE
networktest-56fc4fb64c-skxqx   1/1       Running   0          4s        10.244.0.5   node-0
```

**Confirm Node-to-Pod communication:**
```shell
NODE_SSH_IP=$(echo $NODE_SSH_IPS | cut -d ',' -f 1)
POD_NAME=$(kubectl get pods -l run=networktest -o jsonpath="{.items[0].metadata.name}")
POD_IP=$(kubectl get pod $POD_NAME -o jsonpath="{.status.podIP}")
ssh $SSH_USER@$NODE_SSH_IP ping $POD_IP
```
⤹
```
PING 10.244.0.5 (10.244.0.5) 56(84) bytes of data.
64 bytes from 10.244.0.5: icmp_seq=1 ttl=64 time=0.040 ms
64 bytes from 10.244.0.5: icmp_seq=2 ttl=64 time=0.040 ms
64 bytes from 10.244.0.5: icmp_seq=3 ttl=64 time=0.050 ms
```

**Confirm Pod-to-Node communication:**
```shell
POD_NAME=$(kubectl get pods -l run=networktest -o jsonpath="{.items[0].metadata.name}")
POD_HOST_IP=$(kubectl get pod $POD_NAME -o jsonpath="{.status.hostIP}")
kubectl exec $POD_NAME -- ping $POD_HOST_IP
```
⤹
```
PING 10.100.0.128 (10.100.0.128): 56 data bytes
64 bytes from 10.100.0.128: seq=0 ttl=64 time=0.074 ms
64 bytes from 10.100.0.128: seq=1 ttl=64 time=0.088 ms
64 bytes from 10.100.0.128: seq=2 ttl=64 time=0.117 ms
```

**Confirm Pod-to-Pod communication:**
```shell
POD_IP=$(kubectl get pod $POD_NAME -o jsonpath="{.status.podIP}")
kubectl run -it --rm --restart=Never pod-to-pod-networking --image=busybox env "POD_IP=$POD_IP" sh
```
⤹
```
If you don't see a command prompt, try pressing enter.
/ #
```

**List network interfaces inside Pod, from Node:**
```shell
POD_NAME=$(kubectl get pods -l run=networktest -o jsonpath="{.items[0].metadata.name}")
CONTAINER_ID=$(kubectl get pod $POD_NAME -o jsonpath='{.status.containerStatuses[0].containerID}' | awk -F/ '{print $3}')
CONTAINER_PID=$(echo $(ssh $SSH_USER@$NODE_SSH_IP sudo runc list | grep $CONTAINER_ID) | awk '{print $2}')
ssh $SSH_USER@$NODE_SSH_IP sudo nsenter -t $CONTAINER_PID -n ip addr
```
⤹
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
3: eth0@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 0a:58:0a:f4:00:05 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.0.5/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::64ac:5eff:fed2:e4a1/64 scope link
       valid_lft forever preferred_lft forever
```

**Additional Reading**
- TBD
- TBD

## Kubernetes DNS
> One line that explains DNS in the context of Kubernetes.

**Build in support for DNS:**
```
./kwm dns
```

**Additional Reading**
- TBD
- TBD

### Acknowledgements
It was quite a challenge learning how to do this. Here are some resources I used
along the way:

* [Kubernetes Documentation]
* [Kubernetes the Hard Way]
* [Deploying Kubernetes from Scratch]
* [Kube-Linode]
* [Linux Networking Explained]

[Bootkube]: https://github.com/kubernetes-incubator/bootkube
[Traefik]: https://github.com/containous/traefik
[Kubernetes Documentation]: https://kubernetes.io/docs/home/
[Kubernetes the Hard Way]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[Deploying Kubernetes from Scratch]: https://nixaid.com/deploying-kubernetes-cluster-from-scratch/
[Kube-Linode]: https://github.com/kahkhang/kube-linode
[Linux Networking Explained]: http://events.linuxfoundation.org/sites/events/files/slides/2016%20-%20Linux%20Networking%20explained_0.pdf
-->
