load $(which batshit-helpers)

INDIRECT_HOME=$(pwd)
source indirect.sh

@test "no args" {
  run indirect
  assert_output_contains "Usage: "
  assert_failure
}
