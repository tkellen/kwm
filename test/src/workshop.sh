cd ../..

. src/workshop.sh

test_workshop() {
  local expected actual

  assert_status_code 1 workshop \
    "should exit with status code 1 when no workshop is requested"

}
