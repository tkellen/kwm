. src/lib/validateEnv.sh
. src/lib/error.sh
. src/lib/findNodes.sh
. src/lib/magicEtcdMeta.sh
. src/lib/render.sh

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
  exit 0
}
