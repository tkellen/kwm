. ${BASE_PATH}src/lib/nodeValue.sh
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
getNodeMeta() {
  local nodeKey=${1:-""}
  export KWM_ROLE="${KWM_ROLE:-$(nodeValue $nodeKey ROLE)}"
  export KWM_HOSTNAME="${KWM_HOSTNAME:-$(nodeValue $nodeKey HOSTNAME)}"
  export KWM_CONNECT="${KWM_CONNECT:-$(nodeValue $nodeKey CONNECT)}"
  export KWM_PRIVATE_IP="${KWM_PRIVATE_IP:-$(nodeValue $nodeKey PRIVATE_IP)}"
}

export -f getNodeMeta # allow subprocesses to access these functions
