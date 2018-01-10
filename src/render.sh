. src/globals.sh
. src/compile.sh
. src/error.sh

render() {
  local namespace=$1
  local key=$2
  local template="$TEMPLATE_PATH/$namespace/$key"
  local embedded_template_key="template_${namespace}_${key//-/_}"
  local embedded_template=${!embedded_template_key}
  # prefer template files on disk if they are available
  if [[ ! -f $template && -z $embedded_template ]]; then
    missing=$key error resource-not-found
    printf "\n"
    render usage $namespace
    exit 1
  fi
  if [[ -f $template ]]; then
    compile "$(cat $template)" | bash
  else
    compile "$embedded_template" | bash
  fi
}

# This must be exported to allow templates to render partial content.
export -f render
