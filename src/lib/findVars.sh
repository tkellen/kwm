##
# Return a list of in-scope variables that contain the supplied string.
#
findVars() {
  declare -xp | sed 's/declare -x \([^=]*\)=.*/\1/g' | grep "$1"
}
