. src/globals.sh
. src/render.sh
. src/magicNodeMeta.sh
. src/error.sh
. src/highlight.sh

##
# Display current values in environment for a specified type of resource.
#
getenv() {
  local type=$1
  local nodeKey=$2
  if [[ -z $type ]]; then
    render usage env
    exit 1
  fi
  if [[ $type =~ node ]]; then
    magicNodeMeta $nodeKey
    if [[ -z $nodeKey ]]; then
      type=$type error no-node-for-env
      printf "\n"
    fi
  fi
  magicEtcdMeta
  highlight
  VALIDATE=false render env $type
}
