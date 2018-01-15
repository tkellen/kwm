cd ../..

. src/workshop.sh

goodCall() {
  workshop environment-variables
}

test_workshop() {
  local expected actual

  assert_status_code 0 goodCall "when valid workshop is requested"
  assert_status_code 1 workshop "when no workshop is requested"
}
