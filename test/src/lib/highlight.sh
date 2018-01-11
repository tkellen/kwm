cd ../../..

. src/lib/highlight.sh

test_highlight() {
  export KWM_TEST=test
  local expected="$(tput setaf 4)test$(tput op)"

  highlight false

  assert_equals "test" $KWM_TEST \
    "should be a noop false is passed"

  highlight true

  assert_equals "$expected" $KWM_TEST \
    "should eval all KWM* variables and highlight them if true is passed"
}
