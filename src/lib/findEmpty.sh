findEmpty() {
  local empty
  for varname in "$@"; do
    if [[ -z ${!varname} ]]; then
      empty+="$varname"$'\n'
    fi
  done
  printf "$empty"
}
