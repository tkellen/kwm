function worker-pki {
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
  render log message:="Generating private key for kublet."
  render private-key name:="kubelet" basePath:=".$basePath"
  render log message:="Generating private key for kube-router."
  render private-key name:="kube-router" basePath:=".$basePath"
  render log message:="Generating cluster-ca signed certificate for kubelet to apiserver communication."
  render signed-cert ca:="cluster" name:="kubelet" subj:="/CN=system:node:$name/O=system:nodes" ext:="subjectAltName = IP:$privateIp,DNS:$name" basePath:=".$basePath" caPath:=".$basePath"
  render log message:="Generating cluster-ca signed certificate for kube-router to apiserver communication."
  render signed-cert ca:="cluster" name:="kube-router" subj:="/CN=kube-router" ext:="" basePath:=".$basePath" caPath:=".$basePath"
}
