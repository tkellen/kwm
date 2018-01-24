cd ../..

. src/start.sh

test_start() {
  assert_status_code 1 start \
    "should exit with status code 1 when environment is missing"
}
