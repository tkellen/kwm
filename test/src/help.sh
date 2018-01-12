cd ../..

. src/help.sh

test_help() {
  assert_status_code 0 help
}
