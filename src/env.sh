. src/lib/error.sh
. src/lib/highlight.sh
. src/lib/magicNodeMeta.sh
. src/lib/template.sh

##
# Display current values in environment for a specified resource.
#
getenv() {
  local resource=$1
  local nodeKey=$2
  local envRequired="env_${resource/-/_}[*]"
  if [[ -z $resource ]]; then
    template usage env
    exit 1
  fi
  if [[ $resource =~ node ]]; then
    magicNodeMeta $nodeKey
    if [[ -z $nodeKey ]]; then
      error "$(resource=$resource template no-node-for-env)"
      exit 1
    fi
  fi
  magicEtcdMeta
  highlight $STDOUT_IS_TERMINAL
  for key in ${!envRequired}; do
    printf "%s\n" "${key}=\"${!key}\""
  done
  exit 0
}
