. src/render.sh
. src/error.sh

validateEnv() {
  local method=$1
  local type=$2
  local errors="$(VALIDATE=true render env $type)"
  if [[ -n $errors ]]; then
    errors="$errors" type="$type" method="$method" error env-missing
    exit 1
  fi
}
