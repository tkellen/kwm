. src/globals.sh

##
#
#
showVar() {
  local key=$1
  local defaultValue=$2
  local envValue=${!key}
  local value=${envValue:-$defaultValue}
  if [[ $VALIDATE == false || ($VALIDATE == true && -z $value) ]]; then
    printf "$key=\"$value\"\n"
  fi
}

# This must be exported to allow templates to render partial content.
export -f showVar
