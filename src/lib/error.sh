##
# Output supplied string in red color.
#
error() {
  (
    tput setaf 1
    printf "%s" "$1"
    tput op
  ) >&2
}
export -f error # allow subprocesses to access this method
