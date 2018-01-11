. src/lib/render.sh

##
# Get a list of possible environment values to be defined. In the development of
# KWM these values are read from disk. For end users, the templates are inlined
# into the script.
#
_getDefinable() {
  if [[ $VERSION == dev ]]; then
    printf "%s\n" "$(ls src/template/define)"
  else
    printf "%s\n" "$(template_define)"
  fi
}

##
# Display details about a KWM_* environment variable.
#
define() {
  local var=$1
  if [[ -z $var ]]; then
    vars="$(_getDefinable)" render usage define
    exit 1
  fi
  printf "%s\n" $var
  render define $var
}
