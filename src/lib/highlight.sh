# Colorize all variables beginning with the string KWM. This makes them easy
# to see in rendered templates.
highlightAll() {
  for name in ${!KWM*}; do
    eval $name=\"$(tput setaf 4)${!name}$(tput op)\"
  done
}

highlight() {
  if $STDOUT_IS_TERMINAL; then
    tput setaf 4
    sed "s/\x1B\[[0-9;]*m//g" <<<"$1"
    tput op
  else
    printf "$1"
  fi
}
export -f highlight highlightAll # allow subprocesses to access these functions
