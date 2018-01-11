cd ../..

. src/define.sh

test_define() {
  local expected actual

  assert_status_code 1 define \
    "should exit with status code 1 when no definition is requested"

  actual="$(define KWM_CONNECT)"
  expected="KWM_CONNECT
$(cat src/template/define/KWM_CONNECT)"

  assert_equals "$actual" "$expected" \
    "should display definition requested"
}
