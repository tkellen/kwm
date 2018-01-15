cd ../..

. src/nodes.sh

goodCall() {
  KWM_ROLE_node1=test KWM_ROLE_node2=test nodes all
}

test_nodes() {
  assert_status_code 0 goodCall "when valid node role is defined"
  assert_status_code 1 nodes "when no node role is defined"
}
