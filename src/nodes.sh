. ${BASE_PATH}src/lib/error.sh
. ${BASE_PATH}src/lib/findNodes.sh
. ${BASE_PATH}src/lib/template.sh

# List all nodes in the environment filtered by their role.
nodes() {
  local role=${1:-""}
  # If no role defined, bail with usage screen.
  [[ -z $role ]] && template usage nodes && exit 1
  # Find all unique KWM_ROLE_[nodeKey] entries for specifed role
  local nodes="$(findNodes $role)"
  # If none found, bail with error screen.
  [[ -z $nodes ]] && error "$(template error no_nodes_for_role)" && exit 1
  # Print the node keys!
  printf "%s\n" "$nodes"
  exit 0
}
