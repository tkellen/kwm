# Give help system access to the current version of KWM.
VERSION=dev

# Get an absolute path to KWM itself.
SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

# Get the name of KWM, just in case it has been changed.
SCRIPT_NAME="$(basename -- "$0")"

# Assemble a path to templates.
TEMPLATE_PATH="${TEMPLATE_PATH:-$SCRIPT_PATH/src/template}"
# Many commands highlight user supplied input with coloring. This variable is
# used to control instances where colors should not be applied. For example,
# a user may run `kwm script pki` to inspect the commands needed to generate
# PKI for Kubernetes. If they actually want to execute those commands, as in
# `kwm script pki | bash`, the highlighting of their values should not be
# present.
if [[ ! -t 1 ]]; then
  STDOUT_IS_TERMINAL=false
else
  STDOUT_IS_TERMINAL=true
fi

# A convenience flag that allows users to generate invalid scripts and manifests
# by providing partially complete environment values. This makes it easy to
# explore where individual enviroment values wind up.
case "$@" in
  *--ignore-missing-env*) IGNORE_MISSING_ENV=true ;;
esac

# TODO: eliminate this gross thing
VALIDATE=false
