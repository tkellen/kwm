function worker-render {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  local nodePath="$clusterPath/$name$basePath"
  mkdir -p $nodePath $installPath $servicePath $containerNetworkPath

  echo "[$name] Rendering kubelet.kubeconfig."
  render kubeconfig \
    name:="kubelet" \
    user:="system:node:$name" \
    basePath:="$basePath" \
    clusterName:="$clusterName" \
    apiserver:="$apiserver" > "$nodePath/kubelet.kubeconfig"

  echo "[$name] Rendering kube-router.kubeconfig."
  render kubeconfig \
    name:="kube-router" \
    user:="kube-router" \
    basePath:="$basePath" \
    clusterName:"$clusterName" \
    apiserver:="$apiserver" > "$nodePath/kube-router.kubeconfig"

  echo "[$name] Rendering container network bridge configuration."
  render container-network-bridge \
    podCidr:="$podCidr" > "$containerNetworkPath/10-kuberouter.conf"

  echo "[$name] Rendering container network loopback configuration."
  render container-network-loopback > "$containerNetworkPath/99-loopback.conf"

  echo "[$name] Rendering kublet service file."
  render systemd-unit \
    name:="kubelet" \
    after:="cri-containerd.service" \
    requires:="cri-containerd.service" \
    exec:="$(
      render exec-kubelet \
        basePath:="$basePath" \
        privateIp:="$privateIp" \
        podCidr:="$podCidr" \
        dnsServiceIp:="$dnsServiceIp" \
        role:="$role"
    )" > "$servicePath/kubelet.service"

  echo "[$name] Rendering kube-router service file."
  render systemd-unit \
    name:="kube-router" \
    after:="network.target" \
    requires:="kubelet.service" \
    exec:="$(
      render exec-kube-router \
        basePath:="$basePath" \
        podCidr:="$podCidr"
    )" > "$servicePath/kube-router.service"
}
