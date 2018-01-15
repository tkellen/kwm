. ${BASE_PATH}src/lib/error.sh
. ${BASE_PATH}src/lib/nodeValue.sh
. ${BASE_PATH}src/lib/template.sh

# Connect to a Node by executing the command specified under
# KWM_CONNECT_[nodeKey].
connect() {
  local nodeKey=${1:-""}
  # Look up KWM_CONNECT_[nodeKey]
  local call=$(nodeValue $nodeKey CONNECT)
  # If no node is defined, bail with usage screen.
  [[ -z $nodeKey ]] && template usage connect && exit 1
  # If node cannot be found in environment, bail with a notification.
  [[ -z $call ]] && error "$(requested=$nodeKey template error invalid-node)" && exit 1
  # Execute KWM_CONNECT for the specified node.
  $call
  exit 0
}
