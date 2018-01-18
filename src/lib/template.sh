. ${BASE_PATH}src/lib/error.sh

# Render templates from disk or embedded lookup functions.
template() {
  local namespace=${1:-""}
  local key=${2:-""}
  local templateContent
  # Look for requested template on disk
  local templatePath="${BASE_PATH}template/$namespace/$key"
  # Look for inline template function (built, single-file mode)
  local templateFn="template_${namespace}_${key}"
  # When operating in built mode, a lookup function for each namespace
  # exists. If that function can be found, use it to find the template content.
  if [[ $TEMPLATES_BUNDLED == true ]]; then
    templateContent="$($templateFn)"
  elif [[ -f "$templatePath" ]]; then
    templateContent="$(cat "$templatePath")"
  fi

  # If rendering the requested template is blank, bail with error screen.
  if [[ -z $templateContent ]]; then
    # Prevent recursive loop trying to find "resource-not-found" error.
    if [[ $namespace == error ]]; then
      printf "%s\n" "This is pretty bad."
    else
      # Show error stating template couldn't be found. This could cause a
      # recursive loop without the above conditional if the "resource-not-found"
      # template could not be found.
      error "$(missing=$key template error resource-not-found)"
    fi
    exit 1
  fi
  # Render our template and "compile" it by passing it into bash.
  _compile "$(sed 's/\\/\\\\/g' <<<"$templateContent")" | bash
}

# Make a string blue.
header() {
  printf "$(tput setaf 4)$1$(tput op)"
}

# Take a literal string that may contain variables and function calls and drop
# it into a heredoc string for later evaluation by bash.
# This is pretty voodoo :D.
_compile() {
  printf "%b\n" "cat <<RENDER"
  printf "%b\n" "$1"
  printf "%b\n" "RENDER"
}
export -f template header _compile  # allow subprocesses to access these functions
