. src/lib/error.sh
. src/lib/nodeValue.sh
. src/lib/template.sh

##
# Connect to a Node by executing the command specified under
# KWM_CONNECT_[nodeKey].
#
connect() {
  local nodeKey=$1
  # Look up KWM_CONNECT_[nodeKey]
  local call=$(nodeValue $nodeKey CONNECT)
  # If no node is defined, bail with usage screen.
  if [[ -z $nodeKey ]]; then
    template usage connect
    exit 1
  fi
  # If node cannot be found in environment, bail with a notification.
  if [[ -z $call ]]; then
    error "$(requested=$nodeKey template error invalid-node)"
    exit 1
  fi
  # Execute KWM_CONNECT for the specified node.
  $call
  exit 0
}
