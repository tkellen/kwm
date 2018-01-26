# Enumerate required environment variables for each resource type.
requiredEnv() {
  local key="${1//-/_}"
  local lookup="$key[@]"
  local cluster_admin=(
    KWM_CLUSTER_NAME
    KWM_CONFIG_PATH_LOCAL
    KWM_APISERVER_PUBLIC_IP
  )
  local cni_manifest=(
    KWM_CONFIG_PATH_REMOTE
    KWM_VERSION_KUBE_ROUTER
  )
  local copy_node_assets=(
    KWM_ROLE
    KWM_CONNECT
    KWM_CONFIG_PATH_LOCAL
    KWM_CONFIG_PATH_REMOTE
  )
  local dns_manifest=(KWM_VERSION_KUBE_DNS KWM_DNS_SERVICE_IP)
  local encryption_config=(
    KWM_ENCRYPTION_KEY
  )
  local install_container_networking=(
    KWM_CONFIG_PATH_REMOTE
    KWM_CLUSTER_NAME
    KWM_APISERVER_PRIVATE_IP
    KWM_VERSION_CRI_CONTAINERD
    KWM_VERSION_CNI_PLUGIN
  )
  local install_etcd=(
    KWM_VERSION_ETCD
    KWM_CONFIG_PATH_REMOTE
    KWM_HOSTNAME
    KWM_PRIVATE_IP
    KWM_ETCD_INITIAL_CLUSTER
  )
  local install_kube_apiserver=(
    KWM_VERSION_KUBERNETES
    KWM_CONFIG_PATH_REMOTE
    KWM_PRIVATE_IP
    KWM_SERVICE_CIDR
    KWM_ETCD_SERVERS
  )
  local install_kube_controller_manager=(
    KWM_VERSION_KUBERNETES
    KWM_CONFIG_PATH_REMOTE
    KWM_CLUSTER_NAME
    KWM_SERVICE_CIDR
    KWM_POD_CIDR
  )
  local install_kube_scheduler=(
    KWM_VERSION_KUBERNETES
  )
  local install_kubectl=(
    KWM_VERSION_KUBERNETES
  )
  local install_kubelet=(
    KWM_CONFIG_PATH_REMOTE
    KWM_HOSTNAME
    KWM_CLUSTER_NAME
    KWM_APISERVER_PRIVATE_IP
    KWM_VERSION_KUBERNETES
    KWM_PRIVATE_IP
    KWM_DNS_SERVICE_IP
    KWM_POD_CIDR
    KWM_ROLE
  )
  local install_socat=()
  local pki_create_ca=(
    KWM_PKI_PATH
    KWM_PKI_SUBJ
    KWM_PKI_NAME
  )
  local pki=(
    KWM_CONFIG_PATH_LOCAL
    KWM_CLUSTER_NAME
    KWM_ETCD_CLIENT_SANS
  )
  local pki_create_private_key=(
    KWM_PKI_PATH
    KWM_PKI_NAME
  )
  local pki_create_public_key=(
    KWM_PKI_PATH
    KWM_PKI_NAME
  )
  local pki_create_signed_cert=(
    KWM_PKI_PATH
    KWM_PKI_NAME
    KWM_PKI_SUBJ
    KWM_PKI_CA
  )
  local set_hostname=(
    KWM_HOSTNAME
  )
  local start_controlplane_node=(
    KWM_APISERVER_PUBLIC_IP
    KWM_SERVICE_CIDR
    KWM_KUBERNETES_SERVICE_IP
    ${set_hostname[@]}
    ${install_kube_apiserver[@]}
    ${install_kube_controller_manager[@]}
    ${install_kube_scheduler[@]}
    ${install_kubectl[@]}
  )
  local start_etcd_node=(
    ${set_hostname[@]}
    ${install_etcd[@]}
  )
  local start_worker_node=(
    ${set_hostname[@]}
    ${install_container_networking[@]}
    ${install_kubelet[@]}
  )
  local start=(
    KWM_APISERVER_PRIVATE_IP
    KWM_APISERVER_PUBLIC_IP
    KWM_CLUSTER_NAME
    KWM_CONFIG_PATH_LOCAL
    KWM_CONFIG_PATH_REMOTE
    KWM_DNS_SERVICE_IP
    KWM_ENCRYPTION_KEY
    KWM_KUBERNETES_SERVICE_IP
    KWM_POD_CIDR
    KWM_SERVICE_CIDR
    KWM_VERSION_CNI_PLUGIN
    KWM_VERSION_CRI_CONTAINERD
    KWM_VERSION_ETCD
    KWM_VERSION_KUBERNETES
    KWM_VERSION_KUBE_DNS
    KWM_VERSION_KUBE_ROUTER
  )
  [[ -z "${!lookup:-}" ]] && exit 1
  # return only unique values
  tr ' ' '\n' <<<"${!lookup}" | sort -u | tr '\n' ' '
}

export -f requiredEnv # allow subprocesses to access these functions
