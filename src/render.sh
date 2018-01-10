. src/error.sh

_compile() {
  echo "cat <<RENDER"
  echo "$1"
  echo "RENDER"
}

# This must be exported to allow templates to render partial content.

render() {
  local namespace=$1
  local key=$2
  local templatePath="$TEMPLATE_PATH/$namespace/$key"
  local templateFn="template_${namespace}"
  local templateContent
  if [[ -n $(type -t $templateFn) ]]; then
    templateContent="$($templateFn ${key//-/_})"
  else
    templateContent="$(cat $templatePath)"
  fi
  if [[ -z $templateContent ]]; then
    missing=$key error resource-not-found
    printf "\n"
    render usage $namespace
    exit 1
  fi
  _compile "$templateContent" | bash
}

# This must be exported to allow templates to render partial content.
export -f _compile render
