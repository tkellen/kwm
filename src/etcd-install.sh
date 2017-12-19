function etcd-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done
  render log message:="Ensuring hostname and loopback reference are set."
  render set-hostname name:="$name"
  render log message:="Installing etcd at version $version."
  render install-etcd version:="$version"
  render log message:="Enabling and restarting service."
  render enable-service name:="etcd"
}
