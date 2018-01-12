##
# These "magic" functions somewhat violate the premise of this project and may
# be removed in future revisions.
#
. src/lib/findNodes.sh
. src/lib/nodeValue.sh

##
# Populate etcd values based on configuration for any Node with a KWM_ROLE that
# contains "etcd".
#
# During PKI generation, etcd cluster bootstrapping, and configuring
# kube-apiserver, a full list of IPs and hostnames for etcd Nodes in various
# formats is needed.
#
magicEtcdMeta() {
  export KWM_ETCD_INITIAL_CLUSTER=${KWM_ETCD_INITIAL_CLUSTER:-$(_magicEtcdInitialCluster)}
  export KWM_ETCD_CLIENT_SANS=${KWM_ETCD_CLIENT_SANS:-$(_magicEtcdClientSans)}
  export KWM_ETCD_SERVERS=${KWM_ETCD_SERVERS:-$(_magicEtcdServers)}
}

##
# Generate all valid Subject Alternative Names for securing communication from
# the apiserver to etcd.
#
_magicEtcdClientSans() {
  local output
  for node in $(findNodes etcd); do
    output+=",IP:$(nodeValue $node PRIVATE_IP),DNS:$(nodeValue $node HOSTNAME)"
  done
  [[ -n $output ]] && printf "%s\n" ${output:1}
}

##
# Generate the value passed to etcd's "--initial-cluster" flag when spinning up
# a new cluster.
#
_magicEtcdInitialCluster() {
  local output=""
  for node in $(findNodes etcd); do
    output+=",$(nodeValue $node HOSTNAME)=https://$(nodeValue $node PRIVATE_IP):2380"
  done
  [[ -n $output ]] && printf "%s\n" ${output:1}

}

##
# Generate the value passed to kube-apiserver's "--etcd-servers" flag.
#
_magicEtcdServers() {
  local output
  for node in $(findNodes etcd); do
    output+=",https://$(nodeValue $node PRIVATE_IP):2379"
  done
  [[ -n $output ]] && printf "%s\n" ${output:1}
}
