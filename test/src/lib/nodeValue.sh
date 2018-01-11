cd ../../..

. src/lib/nodeValue.sh

test_nodeValue() {
  local expected actual

  expected="mic-check"
  actual="$(KWM_CONNECT=$expected nodeValue nodeKey CONNECT)"
  assert_equals "$expected" "$actual" \
    "should return value from KWM_* when KWM_*_nodeKey is not available"

  expected="mic-check"
  actual="$(KWM_CONNECT=nope KWM_CONNECT_nodeKey=$expected nodeValue nodeKey CONNECT)"
  assert_equals "$expected" "$actual" \
    "should return value from KWM_*_nodeKey over KWM_* when available"

  expected=""
  actual="$(nodeValue nodeKey CONNECT)"
  assert_equals "$expected" "$actual" \
    "should return empty string when no value is found"
}
