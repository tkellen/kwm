. src/lib/render.sh
. src/lib/magicEtcdMeta.sh
. src/lib/magicNodeMeta.sh
. src/lib/validateEnv.sh
. src/lib/highlight.sh

##
# Generate a script for bootstrapping a Kubernetes cluster.
#
script() {
  local type=$1
  local nodeKey=$2
  if [[ -z $type ]]; then
    render usage script
    exit 1
  fi
  magicEtcdMeta
  if [[ $type =~ node ]]; then
    magicNodeMeta $nodeKey
  fi
  validateEnv script $type
  highlight $STDOUT_IS_TERMINAL
  render script $type
}
