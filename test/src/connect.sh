cd ../..

. src/connect.sh

test_connect() {
  local expected actual

  expected="test"
  actual="$(KWM_CONNECT_nodeKey="echo $expected" connect nodeKey)"
  assert_equals "$expected" "$actual" \
    "should execute command defined at KWM_CONNECT_nodeKey"

  KWM_CONNECT="ls" assert_status_code 1 connect \
    "should exit with static code 1 when no matching nodeKey is defined"

  KWM_CONNECT="ls" assert_status_code 1 connect does-not-exist\
    "should exit with static code 1 when invalid nodeKey is defined"
}
