function validate {
  required=$(source settings.example; echo ${!KWM*})
  failed=""
  for var in ${required[@]}; do
    [[ -z "${!var}" ]] && failed+=", ${var}"
  done
  if [ ! -z "$failed" ]; then
    header "Some settings are missing:"
    echo -e "${failed:2}\n"
    header "Before trying again, you may wish to answer these questions:"
    echo "Have I written or generated a settings file yet?"
    echo "Have I exported my settings into my environment? (e.g. \"source my-settings-file\")"
    echo "Does my settings file contain all the needed variables?"
    exit 1
  fi
}
