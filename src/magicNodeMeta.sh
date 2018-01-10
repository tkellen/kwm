. src/nodeValue.sh

##
# When generating scripts for nodes, try to assign environment values in the
# main KWM namespace based on the provided "node key".
#
# That is, if the user has an environment like this:
# KWM_CONNECT_node1="ssh root@55.55.55.55"
# KWM_PRIVATE_IP_node1="10.100.10.1"
# KWM_HOSTNAME_node1="my-first-node"
#
# KWM_CONNECT_node2="ssh root@44.44.44.44"
# KWM_PRIVATE_IP_node2="10.100.10.2"
# KWM_HOSTNAME_node2="my-second-node"
#
# A provided "node key" of "node1" will merge the values into the main KWM
# namespace, like so:
# KWM_CONNECT="ssh root@55.55.55.55"
# KWM_PRIVATE_IP="10.100.10.1"
# KWM_HOSTNAME="my-first-node"
#
magicNodeMeta() {
  local nodeKey=$1
  export KWM_ROLE="${KWM_ROLE:-$(nodeValue $nodeKey ROLE)}"
  export KWM_HOSTNAME="${KWM_HOSTNAME:-$(nodeValue $nodeKey HOSTNAME)}"
  export KWM_CONNECT="${KWM_CONNECT:-$(nodeValue $nodeKey CONNECT)}"
  export KWM_PRIVATE_IP="${KWM_PRIVATE_IP:-$(nodeValue $nodeKey PRIVATE_IP)}"
  export KWM_KUBELET_FLAGS="${KWM_KUBELET_FLAGS:-$(_magicKubeletFlags $nodeKey)}"
}

##
# This "magic" function somewhat violates the premise of this project and may be
# removed at a future date.
#
# This uses the KWM_ROLE value for Nodes to populate role labels and taints for
# Kubelets. This information is used to control where Pods are scheduled. For
# example, it is not recommended to run kube-dns pods on controlplane nodes.
# If a Node's KWM_ROLE of "controlplane" is specified, the Kubelet running on
# that Node will be prevented from running workloads. If a Node's KWM_ROLE is
# "controlplane worker", no taint will be applied because the operator has
# explictly opted into allowing this behavior.
#
_magicKubeletFlags() {
  local node=$1
  local roles="$(nodeValue $node ROLE)"
  local output
  for role in $roles; do
    output+=",node-role.kubernetes.io/$role=true"
  done
  [[ -n $output ]] && output="--node-labels=\"${output:1}\""
  if [[ $roles == *"controlplane"* && $roles != *"worker"* ]]; then
    output+=" --register-with-taints=\"node-role.kubernetes.io/controlplane=true:NoSchedule\""
  fi
  [[ -n $output ]] && echo "$output"
}
