. src/lib/findVars.sh

##
# Find all Node keys specified in the environment.
#
findNodes() {
  local type=$1
  local nodeKey
  for hit in $(findVars "KWM_ROLE_.*"); do
    nodeKey="${hit##*_}"
    if [[ $type == all || ${!hit} =~ $type ]]; then
      printf "%s\n" $nodeKey
    fi
  done
}
export -f findNodes # allow subprocesses to access this method
