cd ../..

. src/startup.sh

test_startup() {
  assert_status_code 1 startup \
    "should exit with status code 1 when environment is missing"
}
