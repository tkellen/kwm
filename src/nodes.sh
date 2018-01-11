. src/lib/render.sh
. src/lib/error.sh
. src/lib/findNodes.sh

##
# List all nodes in the environment filtered by their role.
#
nodes() {
  local role=$1
  if [[ -z $role ]]; then
    render usage nodes
    exit
  fi
  local nodes="$(findNodes $role)"
  if [[ -z $nodes ]]; then
    role=$role error no-nodes-for-role
    exit 1
  fi
  printf "%s\n" "$nodes"
}
