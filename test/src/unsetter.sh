cd ../..

. src/unsetter.sh

test_unsetter() {
  local expected actual

  export KWM_FIRST=set
  export KWM_SECOND=set
  expected=$'unset KWM_FIRST\nunset KWM_SECOND'
  actual="$(STDOUT_IS_TERMINAL=false unsetter)"
  assert_equals "$expected" "$actual" \
    "should return a list of unset commands for every KWM_* value when stdout is not a terminal"
}
