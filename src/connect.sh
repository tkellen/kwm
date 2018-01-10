. src/nodeValue.sh
. src/error.sh

##
# Connect to a Node by executing the command specified under
# KWM_CONNECT_[nodeKey].
#
connect() {
  local nodeKey=$1
  local call
  call=$(nodeValue $nodeKey CONNECT) || return
  if [[ -z $nodeKey ]]; then
    render usage connect
    exit 1
  fi
  if [[ -z $call ]]; then
    requested=$nodeKey error invalid-node
    exit 1
  fi
  $call
}
