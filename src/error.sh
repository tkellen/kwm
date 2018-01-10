error() {
  (tput setaf 1; render error $1; tput op) >&2
}

# This must be exported to allow templates to render partial content.
export -f error
