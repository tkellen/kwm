cd ../..

. src/connect.sh

goodCall() {
  KWM_CONNECT_nodeKey="ls" connect nodeKey
}

test_connect() {
  local expected actual

  assert_status_code 0 goodCall \
    "when command is valid"

  KWM_CONNECT="ls" assert_status_code 1 connect \
    "when no matching nodeKey is defined"

  KWM_CONNECT="ls" assert_status_code 1 connect does-not-exist\
    "when invalid nodeKey is defined"

  expected="test"
  actual="$(KWM_CONNECT_nodeKey="echo $expected" connect nodeKey)"
  assert_equals "$expected" "$actual" \
    "should execute command defined at KWM_CONNECT_nodeKey"

}
