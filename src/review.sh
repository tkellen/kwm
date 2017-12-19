function review {
  echo "Your settings will now be shown individually."
  echo "Enter 'y' or 'n' for each to confirm accuracy and your understanding."
  for name in ${!KWM*}; do
    printf "\n"
    read -p "$name=${!name} [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      continue
    else
      printf "\nExiting."
      exit 0
    fi
  done
  printf "\n\n"
}
