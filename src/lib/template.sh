. src/lib/error.sh

_compile() {
  printf "%b\n" "cat <<RENDER"
  printf "%b\n" "$1"
  printf "%b\n" "RENDER"
}

##
# Render templates from disk (dev) or embedded lookup functions (compiled).
#
template() {
  local namespace=$1
  local key=$2
  local templatePath="src/template/$namespace/$key"
  local templateFn="template_${namespace}"
  local templateContent
  if [[ -n $(type -t $templateFn) ]]; then
    # TOOD: fix this ridiculous tail chasing.
    templateContent="$(sed 's/\\/\\\\\\\\\\n/g' <<<"$($templateFn ${key//-/_})")"
  else
    # TOOD: fix this ridiculous tail chasing.
    templateContent="$(sed 's/\\/\\\\/g' <<<"$(cat $templatePath)")"
  fi
  if [[ -z $templateContent ]]; then
    # TODO: fix case where a recursive loop with no bottom could occur
    missing=$key error resource-not-found
    printf "\n"
    template usage $namespace
    exit 1
  fi
  _compile "$templateContent" | bash
}
export -f _compile template # allow subprocesses to access these functions
