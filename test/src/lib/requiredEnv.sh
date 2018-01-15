cd ../../..

. src/lib/requiredEnv.sh

test_env() {
  local basename
  for resource in template/resource/*; do
    basename=${resource##*/}
    [[ $basename == kubeconfig-manifest ]] && continue
    assert_status_code 0 "requiredEnv $basename" "should know env for $basename"
  done
}
