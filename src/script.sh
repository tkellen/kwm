. src/render.sh
. src/magicEtcdMeta.sh
. src/magicNodeMeta.sh
. src/validateEnv.sh
. src/highlight.sh

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
  highlight
  render script $type
}
