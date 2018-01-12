. src/lib/error.sh
. src/lib/findNodes.sh
. src/lib/template.sh
. src/render.sh

##
# Generate a one-shot script for bootstrapping a Kubernetes cluster. This
# calls out extensively to KWM itself.
#
startup() {
  # give user something useful to go on if no valid nodes are found.
  # at least one for each role is needed.
  if [[ -z "$(findNodes etcd)$(findNodes controlplane)$(findNodes worker)" ]]; then
    error "$(template error startup-no-nodes)"
    exit 1
  fi
  render startup
  exit 0
}
