##
# Find environment variables under nodeKey namespace.
#
# For example:
# KWM_CONNECT=DEFAULT KWM_CONNECT_node1=TEST nodeValue node1 CONNECT
# ^ returns TEST
# KWM_CONNECT=DEFAULT KWM_CONNECT_node1=TEST nodeValue node2 CONNECT
# ^ returns DEFAULT
# KWM_CONNECT_node1=TEST nodeValue node2 CONNECT
# ^ returns nothing
#
nodeValue() {
  local nodeKey=$1
  local var=$2
  local nodeLookup="KWM_${var}_${nodeKey}"
  local defaultLookup="KWM_${var}"
  local nodeValue=${!nodeLookup}
  local defaultValue=${!defaultLookup}
  echo ${defaultValue:-$nodeValue}
}

# This must be exported to allow templates to render partial content.
export -f nodeValue
