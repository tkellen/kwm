##
# Iterate over all provided arguments, checking for their values in the current
# environment. If no value found, print the name of the variable. Used for
# showing users which required variables are missing when attempting to render
# a resource.
#
findEmpty() {
  local empty
  for varname in "$@"; do
    if [[ -z ${!varname} ]]; then
      empty+="$varname"$'\n'
    fi
  done
  printf "$empty"
}
