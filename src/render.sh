. src/lib/template.sh
. src/lib/magicEtcdMeta.sh
. src/lib/magicNodeMeta.sh
. src/lib/highlight.sh
. src/lib/findEmpty.sh

##
# Render a resource template for bootstrapping a Kubernetes cluster.
#
render() {
  local resource=$1
  local nodeKey=$2
  # show help if no resource type is requested
  if [[ -z $resource ]]; then
    template usage render
    exit 1
  fi
  magicEtcdMeta
  if [[ $resource =~ node ]]; then
    magicNodeMeta $nodeKey
  fi
  # find all required environment variables
  local envRequired="env_${resource/-/_}[*]"
  local missing="$(findEmpty ${!envRequired})"
  if [[ -n $missing ]]; then
    error "$(missing="$missing" resource="$resource" template error env-missing)"
    exit 1
  fi
  highlight $STDOUT_IS_TERMINAL
  template resource $resource
  exit 0
}
