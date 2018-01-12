cd ../..

. src/version.sh

test_version() {
  assert_status_code 0 version
}
