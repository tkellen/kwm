cd ../..

. src/render.sh

test_render() {
  assert_status_code 1 render \
    "should exit with status code 1 when no resource is requested"
}
