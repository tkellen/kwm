cd ../..

. src/env.sh

test_env() {
  assert_status_code 0 "getenv pki" "when a valid resource is found"
  assert_status_code 1 "getenv" "when no resource is requested"
  assert_status_code 1 "getenv NOPE" "when non-existent resource is requested"
}
