. src/lib/error.sh
. src/lib/findNodes.sh
. src/lib/template.sh
. src/render.sh

##
# Generate a one-shot script for bootstrapping a Kubernetes cluster. This
# script calls out extensively to KWM itself.
#
startup() {
  if [[ -z "$(findNodes etcd)$(findNodes controlplane)$(findNodes worker)" ]]; then
    error "$(template error startup-no-nodes)"
    exit 1
  fi
  render startup
  exit 0
}
