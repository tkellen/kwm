# Return a list of in-scope variables that contain the supplied string.
findVars() {
  local search=${1:-""}
  declare -xp | sed 's/declare -x \([^=]*\)=.*/\1/g' | grep "$search"
}
