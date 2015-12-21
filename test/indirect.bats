load $(which batshit-helpers)

# . indirect

@test "no args" {
  run indirect
  assert_output_contains "Usage: "
  assert_failure
}
