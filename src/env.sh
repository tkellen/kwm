. src/lib/error.sh
. src/lib/highlight.sh
. src/lib/magicEtcdMeta.sh
. src/lib/magicNodeMeta.sh
. src/lib/template.sh

##
# Display current values in environment for a specified resource.
#
getenv() {
  local resource=$1
  local nodeKey=$2
  # If no resource is defined, bail with a usage screen.
  if [[ -z $resource ]]; then
    template usage env
    exit 1
  fi
  # Find all required environment variables for the specified resource.
  local envRequired="env_${resource/-/_}[*]"
  # If the resource type contains the string node...
  if [[ $resource =~ node ]]; then
    # If a nodeKey isn't defined for a node resource, bail with error.
    if [[ -z $nodeKey ]]; then
      error "$(resource=$resource template error no-node-for-env)"
      printf "\n\n"
    fi
    # Find KWM_*_[nodeKey] values and collapse into root namespace.
    magicNodeMeta $nodeKey
  fi
  # Look at all nodes and build environment variables for etcd.
  magicEtcdMeta
  # If output is bound for a terminal, highlight all KWM_* variables.
  if [[ $STDOUT_IS_TERMINAL == true ]]; then
    highlight
  fi
  # Display all vars needed for the specified resource + their current values.
  for key in ${!envRequired}; do
    printf "%s\n" "${key}=\"${!key}\""
  done
  exit 0
}
