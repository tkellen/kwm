##
# Colorize all variables beginning with the string KWM. This makes them easy
# to see in rendered templates.
#
highlight() {
  for name in ${!KWM*}; do
    eval $name=\"$(tput setaf 4)${!name}$(tput op)\"
  done
}
