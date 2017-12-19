function worker-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  render log message:="Ensuring hostname and loopback reference are set."
  render set-hostname name:="$name"
  render log message:="Installing cri-containerd."
  render install-containerd version:="$criContainerdVersion"
  render enable-service name:="containerd"
  render enable-service name:="cri-containerd"
  render log message:="Installing container networking plugins at version $cniPluginVersion."
  render install-cni-plugins version:="$cniPluginVersion"
  render log message:="Installing kubelet at version $kubernetesVersion."
  render install-k8s name:="kubelet" version:="$kubernetesVersion"
  render enable-service name:="kubelet"
  render log message:="Installing kube-router at version $kubeRouterVersion."
  render install-kube-router version:="$kubeRouterVersion"
  render enable-service name:="kube-router"
  render log message:="Installing socat to power kubectl proxy."
  render install-socat
  echo "sudo systemctl restart containerd"
  # TODO: Fix the containerd restart hack. Without this, pods fail to start with
  # a sandbox error because containerd has not picked up the network config
  # created by kube-router yet.
}
