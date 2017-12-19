function etcd-pki {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done
  render dir-exists dir:="../pki" true:=":" false:="echo 'PKI missing. Please run \"../genpki\" and try again.'; exit 1"
  render local-cmd cmd:="mkdir -p .$basePath"
  render log message:="Pulling in shared PEM files."
  render local-cmd cmd:="cp ../pki/etcd-ca-cert.pem .$basePath"
  render local-cmd cmd:="cp ../pki/etcd-ca-private-key.pem .$basePath" # TODO: REMOVE
  render local-cmd cmd:="cp ../pki/apiserver-to-etcd-cert.pem .$basePath"
  render local-cmd cmd:="cp ../pki/apiserver-to-etcd-private-key.pem .$basePath"
  render log message:="Generating private key for etcd server to etcd server communication."
  render private-key name:="etcd-to-etcd" basePath:=".$basePath"
  render log message:="Generating etcd-ca signed certificate for etcd server to etcd server communication."
  render signed-cert ca:="etcd" name:="etcd-to-etcd" subj:="/CN=etcd-to-etcd/O=etcd" ext:="subjectAltName = IP:$privateIp,DNS:$name" basePath:=".$basePath" caPath:=".$basePath"
}
