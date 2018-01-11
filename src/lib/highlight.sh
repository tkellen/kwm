highlight() {
  if $1; then
    for name in ${!KWM*}; do
      eval $name=\"$(tput setaf 4)${!name}$(tput op)\"
    done
  fi
}
