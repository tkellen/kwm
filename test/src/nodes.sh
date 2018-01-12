cd ../..

. src/nodes.sh

test_nodes() {
  assert_status_code 1 nodes \
    "should exit with status code 1 when no node role is defined"
}
