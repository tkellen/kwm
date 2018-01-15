cd ../../..

. src/lib/magicNodeMeta.sh

test_magicNodeMeta() {
  export KWM_ROLE=controlplane

  export KWM_HOSTNAME_fixture=controlplane
  export KWM_CONNECT_fixture='ssh root@55.55.55.55'
  export KWM_PRIVATE_IP_fixture=10.200.0.1

  assert_equals \
    "$KWM_HOSTNAME$KWM_CONNECT$KWM_PRIVATE_IP" \
    "" \
    "root namespace environment is empty"

  magicNodeMeta fixture

  assert_equals \
    "controlplane" \
    "$KWM_ROLE" \
    "absent node-based values should retain the root namespace default"

  assert_equals \
    "$KWM_HOSTNAME" \
    "$KWM_HOSTNAME_fixture" \
    "should merge node-based values into root namespace"

  assert_equals \
    "$KWM_CONNECT" \
    "$KWM_CONNECT_fixture" \
    "should merge node-based values into root namespace"

  assert_equals \
    "$KWM_PRIVATE_IP" \
    "$KWM_PRIVATE_IP_fixture" \
    "should merge node-based values into root namespace"

}
