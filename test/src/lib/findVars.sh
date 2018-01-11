cd ../../..

. src/lib/findVars.sh

test_findVars() {
  export KWMTESTVALUE=test
  local expected="KWMTESTVALUE"

  assert_equals "$expected" "$(findVars $expected)" \
    "should return all variables defined that contain the search value"

  assert_equals "" "$(findVars NOPE)" \
    "should empty string if no defined variables match the search"
}
