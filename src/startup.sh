. src/validateEnv.sh
. src/error.sh
. src/findNodes.sh
. src/magicEtcdMeta.sh
. src/render.sh

##
# Generate a one-shot script for bootstrapping a Kubernetes cluster. This
# script calls out extensively to KWM itself.
#
startup() {
  validateEnv script startup
  if [[ -z "$(findNodes etcd)$(findNodes controlplane)$(findNodes worker)" ]]; then
    error startup-no-nodes
    exit 1
  fi
  magicEtcdMeta
  render script startup
}
