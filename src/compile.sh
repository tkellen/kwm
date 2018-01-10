. src/globals.sh

compile() {
  echo "SCRIPT_PATH=$SCRIPT_PATH"
  echo "SCRIPT_NAME=$SCRIPT_NAME"
  echo "TEMPLATE_PATH=$TEMPLATE_PATH"
  echo "STDOUT_IS_TERMINAL=$STDOUT_IS_TERMINAL"
  echo "VALIDATE=$VALIDATE"
  echo "IGNORE_MISSING_ENV=$IGNORE_MISSING_ENV"
  echo "VERSION=$VERSION"
  echo "cat <<RENDER"
  echo "$1"
  echo "RENDER"
}

# This must be exported to allow templates to render partial content.
export -f compile
