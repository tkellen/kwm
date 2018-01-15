# Convenience command to add the directory of this script to PATH.
installer() {
  echo "export PATH=\$PATH:\"${BASE_PATH%%/}\""
  exit 0
}
