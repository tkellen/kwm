cd ../..

. src/usage.sh

test_usage() {
  assert_status_code 0 usage
}
