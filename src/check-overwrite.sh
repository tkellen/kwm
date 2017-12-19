function check-overwrite {
  if [ -d "$KWM_PATH" ]; then
    echo "Cluster assets for \"$KWM_NAME\" have been built already."
    printf "\n"
    read -p "Overwrite? [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf $KWM_PATH
      printf "\n\nDestroying $KWM_PATH.\n\n"
    else
      printf "\nExiting."
      exit 0
    fi
  fi
}
