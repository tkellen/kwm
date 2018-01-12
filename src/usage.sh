. src/lib/template.sh

##
# Show main usage screen and prompt for installation if needed.
#
usage() {
  template usage main
  if [[ "$(which $SCRIPT_NAME)" != "$SCRIPT_PATH/$SCRIPT_NAME" ]]; then
    printf "\n"
    error "$(template usage install)"
  fi
  exit 0
}
