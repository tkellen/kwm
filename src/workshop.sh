. ${BASE_PATH}src/lib/template.sh

# Display a workshop.
workshop() {
  local name=${1:-""}
  # If no variable is defined, bail with a usage screen.
  if [[ -z $name ]]; then
    template usage workshop
    exit 1
  fi
  printf "%s\n\n" "${name/-/ }" | tr '[:lower:]' '[:upper:]'
  template workshop ${name/-/_}
  exit 0
}
