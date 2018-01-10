. src/render.sh

##
# Generate commands needed to unset all KWM_* values.
#
unsetter() {
  if $STDOUT_IS_TERMINAL; then
    render usage unset
    exit 0
  fi
  env | grep KWM_.*\= | cut -f1 -d= | xargs -n 1 echo unset
}
