. src/lib/template.sh

##
# Generate commands needed to unset all KWM_* values.
#
unsetter() {
  # If output is bound for a terminal, show usage screen.
  if [[ $STDOUT_IS_TERMINAL == true ]]; then
    template usage unset
    exit 0
  fi
  # ...otherwise list unset calls for all KWM_.* environment variables.
  env | grep KWM_.*\= | cut -f1 -d= | xargs -n 1 echo unset
  exit 0
}
