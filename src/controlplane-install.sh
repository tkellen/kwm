function controlplane-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  render log message:="Sending shared PKI to $name."
  render tar-copy \
    sourcePath:="pki" \
    files:="cluster-ca-cert.pem \
cluster-ca-private-key.pem \
etcd-ca-cert.pem \
etcd-ca-private-key.pem \
apiserver-to-etcd-cert.pem \
apiserver-to-etcd-private-key.pem \
service-account-private-key.pem \
service-account-public-key.pem" \
    basePath:="$basePath" \
    exec:="$exec"

  render log message:="Installing $name."
  render remote-install exec:="$exec" contents:="$(
    render log message:="Generating private key for client to apiserver communication."
    render private-key name:="client-to-apiserver" basePath:="$basePath"
    render log message:="Generating private key for apiserver to kubelet communication."
    render private-key name:="apiserver-to-kubelet" basePath:="$basePath"
    render log message:="Generating cluster-ca signed certificate for client to apiserver communication."
    render signed-cert ca:="cluster" name:="client-to-apiserver" subj:="/CN=kube-apiserver" ext:="subjectAltName = IP:$loadBalancerIp,IP:$kubernetesServiceIp,IP:$privateIp,DNS:$name,DNS:kubernetes,DNS:kubernetes.default,DNS:kubernetes.default.svc,DNS:kubernetes.default.svc.cluster,DNS:kubernetes.default.svc.cluster.local" basePath:="$basePath" caPath:="$basePath"
    render log message:="Generating cluster-ca signed certificate for apiserver to kubelet communication."
    render signed-cert ca:="cluster" name:="apiserver-to-kubelet" subj:="/CN=kube-apiserver-client/O=system:masters" ext:="" basePath:="$basePath" caPath:="$basePath"
    render log message:="Ensuring hostname and loopback reference are set."
    render set-hostname name:="$name"
    render log message:="Installing kube-apiserver at version $version."
    render install-k8s name:="kube-apiserver" version:="$version"
    render log message:="Generating kube-apiserver service file."
    render write-file path:="/etc/systemd/system/kube-apiserver.service" contents:="$(
      render systemd-unit \
        name:="kube-apiserver" \
        after:="network.target" \
        requires:="" \
        exec:="$(
          render exec-kube-apiserver \
            name:="$name" \
            basePath:="$basePath" \
            count:="$count" \
            privateIp:="$privateIp" \
            serviceCidr:="$serviceCidr" \
            etcdHosts:="$etcdHosts"
        )"
    )"
    render log message:="Enabling kube-apiserver service."
    render enable-service name:="kube-apiserver"
    render log message:="Installing kube-controller-manager at version $version."
    render install-k8s name:="kube-controller-manager" version:="$version"
    render write-file path:="/etc/systemd/system/kube-controller-manager.service" contents:="$(
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
        )"
    )"
    render log message:="Enabling kube-controller-manager service."
    render enable-service name:="kube-controller-manager"
    render log message:="Installing kube-scheduler at version $version."
    render install-k8s name:="kube-scheduler" version:="$version"
    render write-file path:="/etc/systemd/system/kube-scheduler.service" contents:="$(
      render systemd-unit \
        name:="kube-scheduler" \
        after:="network.target" \
        requires:="" \
        exec:="$(render exec-kube-scheduler)"
    )"
    render log message:="Enabling kube-scheduler service."
    render enable-service name:="kube-scheduler"
    render log message:="Installing kubectl at version $version."
    render install-k8s name:="kubectl" version:="$version"
  )"
}
