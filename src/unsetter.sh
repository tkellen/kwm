. src/lib/findVars.sh
. src/lib/template.sh

##
# Generate commands needed to unset all KWM_* values.
#
unsetter() {
  # If output is bound for a terminal, show usage screen.
  if [[ $STDOUT_IS_TERMINAL == true ]]; then
    template usage unset
    exit 1
  fi
  # ...otherwise list unset calls for all KWM environment variables.
  findVars "^KWM" | xargs -n 1 echo unset
  exit 0
}
