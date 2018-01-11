. src/lib/render.sh
. src/lib/magicNodeMeta.sh
. src/lib/error.sh
. src/lib/highlight.sh

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
  highlight $STDOUT_IS_TERMINAL
  VALIDATE=false render env $type
  exit 0
}
