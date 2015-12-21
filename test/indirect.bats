load $(which batshit-helpers)

INDIRECT_HOME=$(pwd)
source indirect.sh

@test "no args" {
  run indirect
  assert_output_contains "Usage: "
  assert_failure
}

@test "use of ./packages" {
  run indirect npm
  assert_output_contains "Installing 'npm' packages"
  assert_success
}
