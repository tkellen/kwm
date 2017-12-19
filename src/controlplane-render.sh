function controlplane-render {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  mkdir -p $installPath $servicePath

  echo "[$name] Rendering kube-apiserver service file."
  render systemd-unit name:="kube-apiserver" after:="network.target" requires:="" exec:="$(
    render exec-kube-apiserver \
      name:="$name" \
      basePath:="$basePath" \
      privateIp:="$privateIp" \
      serviceCidr:="$serviceCidr" \
      etcdHosts:="$etcdHosts"
  )" > "$servicePath/kube-apiserver.service"

  echo "[$name] Rendering kube-controller-manager service file."
  render systemd-unit \
    name:="kube-controller-manager" \
    after:="network.target" \
    requires:="" \
    exec:="$(
      render exec-kube-controller-manager \
        basePath:="$basePath" \
        clusterName:="$clusterName" \
        podCidr:="$podCidr" \
        serviceCidr:="$serviceCidr"
    )" > "$servicePath/kube-controller-manager.service"

  echo "[$name] Rendering kube-scheduler service file."
  render systemd-unit \
    name:="kube-scheduler" \
    after:="network.target" \
    requires:="" \
    exec:="$(
      render exec-kube-scheduler
    )" > $servicePath/kube-scheduler.service
}
