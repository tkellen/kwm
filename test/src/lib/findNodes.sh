cd ../../..

. src/lib/findNodes.sh

test_findNodes() {
  export KWM_ROLE_node1=etcd
  export KWM_ROLE_node2=controlplane

  local expected actual

  expected=$'node1\nnode2'
  actual="$(findNodes all)"
  assert_equals "$expected" "$actual" \
    "should return nodeKey of each node with a matching role"

  expected="node1"
  actual="$(findNodes etcd)"
  assert_equals "$expected" "$actual" \
    "should return nodeKey of each node with a matching role"

  expected=""
  actual="$(findNodes worker)"
  assert_equals "$expected" "$actual" \
    "should return empty string when no nodes with matching roles found"
}
