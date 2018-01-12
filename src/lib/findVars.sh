##
# Return a list of in-scope variables that contain the supplied string.
#
findVars() {
  declare -xp | grep "$1" | sed 's/declare -x \(.*\)=.*/\1/g'
}
