cd ../../..

. src/lib/highlight.sh

test_highlight() {
  export KWM_TEST=test
  local expected="$(tput setaf 4)test$(tput op)"

  assert_equals "test" $KWM_TEST

  highlight

  assert_equals "$expected" $KWM_TEST \
    "should eval all KWM* variables and highlight them if true is passed"
}
