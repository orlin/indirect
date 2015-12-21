load $(which batshit-helpers)

INDIRECT_PATH=$(pwd)
source indirect.sh

@test "no args" {
  run indirect
  assert_output_contains "Usage: "
  assert_failure
}
