. ${BASE_PATH}src/lib/error.sh
. ${BASE_PATH}src/lib/highlight.sh
. ${BASE_PATH}src/lib/magicEtcdMeta.sh
. ${BASE_PATH}src/lib/magicNodeMeta.sh
. ${BASE_PATH}src/lib/requiredEnv.sh
. ${BASE_PATH}src/lib/template.sh

# Render a template for bootstrapping a Kubernetes cluster.
render() {
  local resource=${1:-""}
  local nodeKey=${2:-""}
  # If no resource requested, bail with usage screen.
  [[ -z $resource ]] && template usage render && exit 1
  # Look at all nodes and build environment variables for etcd.
  magicEtcdMeta
  # If the resource type is node, collapse all KWM_*_[nodeKey] values.
  [[ $resource =~ node ]] && magicNodeMeta $nodeKey
  # Look up required environment variables.
  local requiredEnv="$(requiredEnv $resource)"
  # Find those that are missing.
  local missing="$(
    for var in $requiredEnv; do
      [[ -z ${!var:-""} ]] && printf "%s\n" "$var"
    done
  )"
  # Allow skipping validation for the convenience of viewing templates.
  if [[ -n $missing && $IGNORE_MISSING_ENV != true ]]; then
    error "$(missing="$missing" resource="$resource" template error env-missing)"
    exit 1
  fi
  # If output is bound for a terminal, highlight all KWM_* variables.
  [[ $STDOUT_IS_TERMINAL == true ]] && highlightAll
  # Render the template
  template resource ${resource}
  exit 0
}
