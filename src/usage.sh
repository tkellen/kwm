. ${BASE_PATH}src/lib/template.sh

# Show main usage screen and prompt for installation if needed.
usage() {
  template usage main
  if [[ "$(which $SCRIPT_NAME)" != "$BASE_PATH$SCRIPT_NAME" ]]; then
    printf "\n"
    error "$(template usage install)"
    exit 1
  fi
  exit 0
}
