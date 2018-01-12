. src/lib/error.sh
. src/lib/template.sh
. src/lib/magicEtcdMeta.sh
. src/lib/magicNodeMeta.sh
. src/lib/highlight.sh
. src/lib/findEmpty.sh

##
# Render a template for bootstrapping a Kubernetes cluster.
#
render() {
  local resource=$1
  local nodeKey=$2
  # If no resource requested, bail with usage screen.
  if [[ -z $resource ]]; then
    template usage render
    exit 1
  fi
  # Look at all nodes and build environment variables for etcd.
  magicEtcdMeta
  # If the resource type is node...
  if [[ $resource =~ node ]]; then
    # ...find all KWM_*_[nodeKey] values and collapse into root namespace.
    magicNodeMeta $nodeKey
  fi
  # Allow skipping validation for the convenience of viewing templates.
  if [[ $IGNORE_MISSING_ENV == false ]]; then
    # Find all required environment variables for the specified resource.
    local envRequired="env_${resource/-/_}[*]"
    # Find all missing environment variables for the specified resource.
    local missing="$(findEmpty ${!envRequired})"
    # If any environment variables are missing, bail out with an error.
    if [[ -n $missing ]]; then
      error "$(missing="$missing" resource="$resource" template error env-missing)"
      exit 1
    fi
  fi
  # If output is bound for a terminal, highlight all KWM_* variables.
  if [[ $STDOUT_IS_TERMINAL == true ]]; then
    highlight
  fi
  # Render the template!
  template resource $resource
  exit 0
}
