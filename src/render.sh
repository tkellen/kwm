function render {
  local path=$1
  local source="$(cat src/templates/$path)"
  for item in "${@:2}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    # escape replacement text
    IFS= read -d '' -r < <(sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g' <<< "$replace")
    local escaped=${REPLY%$'\n'}
    source="$(
      echo "$source" | sed -e "s^"\\\${${find}}"^$escaped^g"
    )"
  done
  echo "$source"
}
