cd ../..

. src/define.sh

goodCall() {
  define KWM_CONNECT
}

test_define() {
  assert_status_code 0 goodCall "when definition is found"
  assert_status_code 1 define "when no definition is requested"
}
