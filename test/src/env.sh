cd ../..

. src/env.sh

test_env() {
  assert_status_code 1 getenv \
    "should exit with status code 1 when no resource is requested"
}
