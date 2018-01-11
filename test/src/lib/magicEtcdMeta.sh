cd ../../..

. src/lib/magicEtcdMeta.sh

test_magicEtcdMeta() {
  export KWM_ROLE_controlplane=controlplane
  export KWM_PRIVATE_IP_controlplane=10.200.0.1
  export KWM_HOSTNAME_controlplane=controlplane

  export KWM_ROLE_worker=worker
  export KWM_PRIVATE_IP_worker=10.200.0.1
  export KWM_HOSTNAME_worker=worker

  export KWM_ROLE_dkvs0=etcd
  export KWM_PRIVATE_IP_dkvs0=10.100.0.1
  export KWM_HOSTNAME_dkvs0=etcd0

  export KWM_ROLE_dkvs1=etcd
  export KWM_PRIVATE_IP_dkvs1=10.100.0.2
  export KWM_HOSTNAME_dkvs1=etcd1

  export KWM_ROLE_dkvs2=etcd
  export KWM_PRIVATE_IP_dkvs2=10.100.0.3
  export KWM_HOSTNAME_dkvs2=etcd2

  magicEtcdMeta

  local initialCluster="etcd0=https://10.100.0.1:2380,etcd1=https://10.100.0.2:2380,etcd2=https://10.100.0.3:2380"
  local clientSans="IP:10.100.0.1,DNS:etcd0,IP:10.100.0.2,DNS:etcd1,IP:10.100.0.3,DNS:etcd2"
  local servers="https://10.100.0.1:2379,https://10.100.0.2:2379,https://10.100.0.3:2379"

  assert_equals "$initialCluster" "$KWM_ETCD_INITIAL_CLUSTER" \
    "should populate flags for etcd bootstrapping based on environment"
  assert_equals "$clientSans" "$KWM_ETCD_CLIENT_SANS" \
    "should populate subjectAltNames for openssl to generate pki"
  assert_equals "$servers" "$KWM_ETCD_SERVERS" \
    "should populate list of etcd hosts for kube-apiserver"
}
