function controlplane-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done
  render log message:="Ensuring hostname and loopback reference are set."
  render set-hostname name:="$name"
  render log message:="Installing kube-apiserver at version $version."
  render install-k8s name:="kube-apiserver" version:="$version"
  render log message:="Enabling kube-apiserver service."
  render enable-service name:="kube-apiserver"
  render log message:="Installing kube-controller-manager at version $version."
  render install-k8s name:="kube-controller-manager" version:="$version"
  render log message:="Enabling kube-controller-manager service."
  render enable-service name:="kube-controller-manager"
  render log message:="Installing kube-scheduler at version $version."
  render install-k8s name:="kube-scheduler" version:="$version"
  render log message:="Enabling kube-scheduler service."
  render enable-service name:="kube-scheduler"
  render log message:="Installing kubectl at version $version."
  render install-k8s name:="kubectl" version:="$version"
}
