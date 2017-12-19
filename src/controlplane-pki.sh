function controlplane-pki {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done
  render dir-exists dir:="../pki" true:=":" false:="echo 'PKI missing. Please run \"../genpki\" and try again.'; exit 1"
  render local-cmd cmd:="mkdir -p .$basePath"
  render log message:="Pulling in shared PEM files."
  render local-cmd cmd:="cp ../pki/cluster-ca-cert.pem .$basePath"
  render local-cmd cmd:="cp ../pki/cluster-ca-private-key.pem .$basePath" # TODO: REMOVE
  render local-cmd cmd:="cp ../pki/etcd-ca-cert.pem .$basePath"
  render local-cmd cmd:="cp ../pki/etcd-ca-private-key.pem .$basePath" # TODO: REMOVE
  render local-cmd cmd:="cp ../pki/apiserver-to-etcd-cert.pem .$basePath"
  render local-cmd cmd:="cp ../pki/apiserver-to-etcd-private-key.pem .$basePath"
  render local-cmd cmd:="cp ../pki/service-account*.pem .$basePath"
  render log message:="Generating private key for client to apiserver communication."
  render private-key name:="client-to-apiserver" basePath:=".$basePath"
  render log message:="Generating private key for apiserver to kubelet communication."
  render private-key name:="apiserver-to-kubelet" basePath:=".$basePath"
  render log message:="Generating cluster-ca signed certificate for client to apiserver communication."
  render signed-cert ca:="cluster" name:="client-to-apiserver" subj:="/CN=kube-apiserver" ext:="subjectAltName = IP:$kubernetesServiceIp,IP:$sshIp,IP:$privateIp,DNS:$name,DNS:kubernetes,DNS:kubernetes.default,DNS:kubernetes.default.svc,DNS:kubernetes.default.svc.cluster,DNS:kubernetes.default.svc.cluster.local" basePath:=".$basePath" caPath:=".$basePath"
  render log message:="Generating cluster-ca signed certificate for apiserver to kubelet communication."
  render signed-cert ca:="cluster" name:="apiserver-to-kubelet" subj:="/CN=kube-apiserver-client/O=system:masters" ext:="" basePath:=".$basePath" caPath:=".$basePath"
}
