function cluster-pki {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done
  local basePath="pki"

  render dir-exists dir:="$basePath" true:="echo 'PKI has already been generated.'; exit 1" false:=":"
  render log message:="Rendering public key infrastructure."
  render local-cmd cmd:="mkdir -p $basePath"
  render log message:="Generating cluster certificate authority."
  render init-ca name:="cluster" subj:="/CN=$clusterName" basePath:="$basePath"
  render log message:="Generating private key for cluster admin to apiserver communication."
  render private-key name:="cluster-admin-to-apiserver" basePath:="$basePath"
  render log message:="Generating cluster-ca signed certificate for cluster admin to apiserver communication."
  render signed-cert ca:="cluster" name:="cluster-admin-to-apiserver" subj:="/CN=root/O=system:masters" ext:="" basePath:="$basePath" caPath:="$basePath"
  render log message:="Generating etcd certificate authority."
  render init-ca name:="etcd" subj:="/CN=etcd-ca" basePath:="$basePath"
  render log message:="Generating private key for apiserver to etcd server communication."
  render private-key name:="apiserver-to-etcd" basePath:="$basePath"
  render log message:="Generating etcd-ca signed certificate for apiserver to etcd communication."
  render signed-cert ca:="etcd" name:="apiserver-to-etcd" subj:="/CN=etcd" ext:="subjectAltName = $etcdClientSubjectNames" basePath:="$basePath" caPath:="$basePath"
  # TODO: get TLS bootstrapping going to eliminate some PKI creation
  # https://kubernetes.io/docs/admin/bootstrap-tokens/
  render log message:="Generating public/private keypair for service accounts"
  render private-key name:="service-account" basePath:="$basePath"
  render public-key name:="service-account" basePath:="$basePath"
}
