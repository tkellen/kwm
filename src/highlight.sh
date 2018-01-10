. src/globals.sh

highlight() {
  if $STDOUT_IS_TERMINAL; then
    for name in ${!KWM*}; do
      eval $name=\"$(tput setaf 4)${!name}$(tput op)\"
    done
  fi
}
