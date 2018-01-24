. ${BASE_PATH}src/lib/error.sh
. ${BASE_PATH}src/lib/highlight.sh
. ${BASE_PATH}src/lib/magicEtcdMeta.sh
. ${BASE_PATH}src/lib/getNodeMeta.sh
. ${BASE_PATH}src/lib/requiredEnv.sh
. ${BASE_PATH}src/lib/template.sh

# Display current values in environment for a specified resource.
getenv() {
  local resource=${1:-""}
  local nodeKey=${2:-""}
  # If no resource is defined, bail with a usage screen.
  [[ -z $resource ]] && template usage env && exit 1
  # Look up required environment variables
  local requiredEnv="$(requiredEnv $resource)"
  # Bail as bad resource if none found.
  [[ -z $requiredEnv ]] && error "$(missing=$resource template error resource-not-found)" && exit 1
  # If the resource type contains the string node...
  if [[ $resource =~ node ]]; then
    # If a nodeKey isn't defined for a node resource, show error.
    # [[ -z $nodeKey ]] && error "$(resource=$resource template error no-node-for-env)" && printf '\n\n'
    # Find KWM_*_[nodeKey] values and collapse into root namespace.
    getNodeMeta $nodeKey
  fi
  # Look at all nodes and build environment variables for etcd.
  magicEtcdMeta
  # Display all vars needed for the specified resource + their current values.
  for key in $requiredEnv; do
    echo "${key}=\"${!key:-""}\""
  done
  exit 0
}
export -f getenv # allow subprocesses to access these functions
