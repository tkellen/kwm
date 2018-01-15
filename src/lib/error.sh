# Output supplied string in red color.
error() {
  local message=${1:-""}
  (
    tput setaf 1
    printf "%s" "$message"
    tput op
  ) >&2
}
export -f error # allow subprocesses to access this method
