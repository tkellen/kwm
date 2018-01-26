. ${BASE_PATH}src/lib/findVars.sh
. ${BASE_PATH}src/lib/template.sh

# Display details about a KWM_* environment variable.
define() {
  local var=${1:-""}
  # If no variable is defined, bail with a usage screen.
  [[ -z $var ]] && vars="$(_getDefinable)" template usage define && exit 1
  # Show variable name before definition.
  printf "%s\n" "$var (current value: $(echo $(highlight "${!var:-"n/a"}")))"
  # Display definition!
  template define $var
  exit 0
}

# Get a list of possible environment values to be defined. In the development of
# KWM these values are read from disk. In bundled versions of KWM, templates are
# inlined into the script.
_getDefinable() {
  local prefix="template_define_"
  if [[ $VERSION == dev ]]; then
    printf "%s\n" "$(ls ${BASE_PATH}template/define)"
  else
    printf "%s\n" "$(compgen -A function | grep $prefix | sed "s/$prefix//g")"
  fi
}
