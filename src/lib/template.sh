. src/lib/error.sh

##
# Render templates from disk (dev) or embedded lookup functions (compiled).
#
template() {
  local namespace=$1
  local key=$2
  local templateContent
  # Look for requested template on disk (development mode).
  local templatePath="src/template/$namespace/$key"
  # Look for inline template function (built, single-file mode)
  local templateFn="template_${namespace}"
  # When operating in built mode, a lookup function for each namespace
  # exists. If that function can be found, use it to find the template content.
  if [[ -n $(type -t $templateFn) ]]; then
    # Creating a general purpose bash templating system is tricky.
    # A heredoc with parameter substitution turned off (<<'HEREDOC') chews up
    # line continuations in strange ways. This must be resolvable with less
    # tail chasing?
    # TODO: fix this joke excuse of a solution.
    if [[ $namespace == "workshop" ]]; then
      templateContent="$(sed 's/\\/\\\\/g' <<<"$($templateFn ${key//-/_})")"
    else
      templateContent="$(sed 's/\\/\\\\\\\\\\n/g' <<<"$($templateFn ${key//-/_})")"
    fi
  else
    # Same as a above but somehow a little less egregious when content comes
    # from files rather than disk?
    # TODO: fix this joke excuse of a solution.
    templateContent="$(sed 's/\\/\\\\/g' <<<"$(cat $templatePath)")"
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
  _compile "$templateContent" | bash
}

##
# Take a literal string that may contain variables and function calls and drop
# it into a heredoc string for later evaluation by bash.
# This is pretty voodoo :D.
_compile() {
  printf "%b\n" "cat <<RENDER"
  printf "%b\n" "$1"
  printf "%b\n" "RENDER"
}

export -f _compile template # allow subprocesses to access these functions
