function etcd-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  render log message:="Sending shared PKI to $name."
  render tar-copy \
    sourcePath:="pki" \
    files:="etcd-ca-cert.pem etcd-ca-private-key.pem apiserver-to-etcd-private-key.pem apiserver-to-etcd-cert.pem" \
    basePath:="$basePath" \
    exec:="$exec"

  render log message:="Installing $name."
  render remote-install exec:="$exec" contents:="$(
    render log message:="Generating private key for etcd server to etcd server communication."
    render private-key name:="etcd-to-etcd" basePath:="$basePath"
    render log message:="Generating etcd-ca signed certificate for etcd server to etcd server communication."
    render signed-cert ca:="etcd" name:="etcd-to-etcd" subj:="/CN=etcd-to-etcd/O=etcd" ext:="subjectAltName = IP:$KWM_PRIVATE_IP,DNS:$KWM_HOSTNAME" basePath:="$basePath" caPath:="$basePath"
    render log message:="Ensuring hostname and loopback reference are set."
    render set-hostname name:="$name"
    render log message:="Installing etcd at version $version."
    render install-etcd version:="$version"
    render log message:="Generating etcd service file."
    render write-file path:="/etc/systemd/system/etcd.service" contents:="$(
      render systemd-unit \
        name:="etcd" \
        after:="network.target" \
        requires:="" \
        exec:="$(render exec-etcd \
          name:="$name" \
          basePath:="$basePath" \
          privateIp:="$privateIp" \
          initialCluster:="$initialCluster"
        )"
    )"
    render log message:="Enabling and restarting service."
    render enable-service name:="etcd"
  )"
}
