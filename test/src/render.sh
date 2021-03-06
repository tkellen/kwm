cd ../..

. src/render.sh

goodCall() {
  KWM_CLUSTER_NAME=test \
  KWM_ENCRYPTION_KEY=test \
  KWM_ETCD_CLIENT_SANS=test \
  KWM_CONFIG_PATH_LOCAL=test \
    render pki
}

insufficientEnvIgnored() {
  IGNORE_MISSING_ENV=true render pki
}

test_render() {
  assert_status_code 0 goodCall "when valid resource is requested"
  assert_status_code 1 render "when no resource is requested"
  assert_status_code 1 "render nope" "when invalid resource is requested"
  assert_status_code 1 "render assets" \
    "when valid resource is requested with insufficient environment"
  assert_status_code 0 insufficientEnvIgnored \
    "when valid resource is requsted with insufficient environment but this is ignored"
}
