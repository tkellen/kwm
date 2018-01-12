. src/lib/error.sh
. src/lib/template.sh
. src/lib/findNodes.sh

##
# List all nodes in the environment filtered by their role.
#
nodes() {
  local role=$1
  # If no role defined, bail with usage screen.
  if [[ -z $role ]]; then
    template usage nodes
    exit 0
  fi
  # Find all nodes for the specified role (e.g. search for unique KWM_ROLE_[nodeKey] entries).
  local nodes="$(findNodes $role)"
  # If none found, bail with error screen.
  if [[ -z $nodes ]]; then
    error "$(template error no-nodes-for-role)"
    exit 1
  fi
  # Print the node keys!
  printf "%s\n" "$nodes"
  exit 0
}
