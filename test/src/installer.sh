cd ../..

. src/installer.sh

test_installer() {
  assert_status_code 0 installer
}
