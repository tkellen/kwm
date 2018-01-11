cd ../..

. src/unsetter.sh

test_unsetter() {
  export KWM_FIRST=set
  export KWM_SECOND=set
  local result="$(STDOUT_IS_TERMINAL=false unsetter)"

  if grep -q "unset KWM_FIRST" <<<$result; then
    assert true
  else
    assert false "should include environment values that are set"
  fi

  if grep -q "unset KWM_SECOND" <<<$result; then
    assert true
  else
    assert false "should include environment values that are set"
  fi

  if grep -q "unset KWM_SECONDs" <<<$result; then
    assert false "should not include environment values that don't exist"
  else
    assert true
  fi

}
