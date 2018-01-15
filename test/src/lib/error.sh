cd ../../..

. src/lib/error.sh

test_error() {
  local expected="$(tput setaf 1)test$(tput op)"
  local actual="$(error test 2>&1)"
  assert_equals "$expected" "$actual" "prints supplied input, in red, to stderr"
}
