function worker-install {
  # parse key-value pairs passed to function into local variables
  for item in "${@}"; do
    local find=${item%:=*};
    local replace=${item#*:=};
    declare $find="$replace"
  done

  render log message:="Sending shared PKI to $name."
  render tar-copy \
    sourcePath:="pki" \
    files:="cluster-ca-cert.pem cluster-ca-private-key.pem" \
    basePath:="$basePath" \
    exec:="$exec"

  render log message:="Installing $name."
  render remote-install exec:="$exec" contents:="$(
    render log message:="Generating private key for kublet."
    render private-key name:="kubelet" basePath:="$basePath"
    render log message:="Generating private key for kube-router."
    render private-key name:="kube-router" basePath:="$basePath"
    render log message:="Generating cluster-ca signed certificate for kubelet to apiserver communication."
    render signed-cert ca:="cluster" name:="kubelet" subj:="/CN=system:node:$name/O=system:nodes" ext:="subjectAltName = IP:$privateIp,DNS:$name" basePath:="$basePath" caPath:="$basePath"
    render log message:="Generating cluster-ca signed certificate for kube-router to apiserver communication."
    render signed-cert ca:="cluster" name:="kube-router" subj:="/CN=kube-router" ext:="" basePath:="$basePath" caPath:="$basePath"

    render log message:="Ensuring hostname and loopback reference are set."
    render set-hostname name:="$name"
    render log message:="Generating CNI network loopback configuration."
    render write-file path:="/etc/cni/net.d/99-loopback.conf" contents:="$(
      render container-network-loopback
    )"
    render log message:="Installing cri-containerd."
    render install-containerd version:="$criContainerdVersion"
    render enable-service name:="containerd"
    render enable-service name:="cri-containerd"
    render log message:="Installing container networking plugins at version $cniPluginVersion."
    render install-cni-plugins version:="$cniPluginVersion"
    render log message:="Generating kubelet config."
    render write-file path:="/etc/kubernetes/kubelet.kubeconfig" contents:="$(
      render kubeconfig \
        name:="kubelet" \
        user:="system:node:$name" \
        basePath:="$basePath" \
        clusterName:="$clusterName" \
        apiserver:="$apiserver"
    )"
    render log message:="Generating kube-router config."
    render write-file path:="/etc/kubernetes/kube-router.kubeconfig" contents:="$(
      render kubeconfig \
        name:="kube-router" \
        user:="kube-router" \
        basePath:="$basePath" \
        clusterName:="$clusterName" \
        apiserver:="$apiserver"
    )"
    render log message:="Installing kubelet at version $kubernetesVersion."
    render install-k8s name:="kubelet" version:="$kubernetesVersion"
    render log message:="Generating kubelet service."
    render write-file path:="/etc/systemd/system/kubelet.service" contents:="$(
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
        )"
    )"
    render enable-service name:="kubelet"
    render log message:="Installing socat to power kubectl proxy."
    render install-socat
  )"
  #echo "sudo systemctl restart containerd"
  # TODO: Fix the containerd restart hack. Without this, pods fail to start with
  # a sandbox error because containerd has not picked up the network config
  # created by kube-router yet.
}
