. src/globals.sh
. src/render.sh

##
# Get a list of possible environment values to be defined. In the development of
# KWM these values are read from disk. For end users, the templates are inlined
# into the script.
#
_getDefinable() {
  if [[ $VERSION == dev ]]; then
    echo "$(ls $TEMPLATE_PATH/define)"
  else
    echo "$(findVars "template_define*" | sed 's/template_define_//g')"
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
  echo $var
  render define $var
}
