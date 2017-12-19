function etcd-render {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  echo "[$name] Rendering etcd service file."
  render systemd-unit \
    name:="etcd" \
    after:="network.target" \
    requires:="" \
    exec:="$(
      render exec-etcd \
        name:="$name" \
        basePath:="$basePath" \
        privateIp:="$privateIp" \
        initialCluster:="$initialCluster"
    )" > "$servicePath/etcd.service"
}
