. src/findVars.sh

##
# Find all Node keys specified in the environment.
#
findNodes() {
  local type=$1
  local nodeKey
  for hit in $(findVars "KWM_ROLE_.*"); do
    nodeKey="${hit##*_}"
    if [[ $type == all || ${!hit} =~ $type ]]; then
      echo $nodeKey
    fi
  done
}

# This must be exported to allow templates to render partial content.
export -f findNodes
