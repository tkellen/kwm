. src/validateEnv.sh
. src/highlight.sh
. src/render.sh

##
# Generate a yaml manifest for application into a cluster.
#
manifest() {
  local type=$1
  if [[ -z $type ]]; then
    render usage manifest
    exit 1
  fi
  validateEnv manifest $type
  highlight
  render manifest $type
}
