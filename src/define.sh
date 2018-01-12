. src/lib/template.sh

##
# Display details about a KWM_* environment variable.
#
define() {
  local var=$1
  # If no variable is defined, bail with a usage screen.
  if [[ -z $var ]]; then
    vars="$(_getDefinable)" template usage define
    exit 1
  fi
  # Show variable name before definition.
  printf "%s\n" $var
  # Display definition!
  template define $var
  exit 0
}

##
# Get a list of possible environment values to be defined. In the development of
# KWM these values are read from disk. In built versions of KWM, templates are
# inlined into the script.
#
_getDefinable() {
  if [[ $VERSION == dev ]]; then
    printf "%s\n" "$(ls src/template/define)"
  else
    printf "%s\n" "$(template_define)"
  fi
}
