#!/usr/bin/env bats

SCRIPT_PATH="${BATS_TEST_DIRNAME}/../scripts/extract-ticket.sh"

setup() {
  export GITHUB_ENV=$(mktemp)
}

teardown() {
  rm -f "$GITHUB_ENV"
}

@test "extracts ticket number from feature branch with prefix" {
  export GITHUB_HEAD_REF="feature/TDN-1234-add-new-feature"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 1234"* ]]
  grep -q "TICKET_NUMBER=1234" "$GITHUB_ENV"
}

@test "extracts ticket number from branch without prefix" {
  export GITHUB_HEAD_REF="bugfix/456-fix-issue"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 456"* ]]
  grep -q "TICKET_NUMBER=456" "$GITHUB_ENV"
}

@test "extracts ticket number from branch with only number" {
  export GITHUB_HEAD_REF="123-some-description"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 123"* ]]
  grep -q "TICKET_NUMBER=123" "$GITHUB_ENV"
}

@test "extracts first ticket number when multiple numbers present" {
  export GITHUB_HEAD_REF="feature/TDN-1234-add-5-new-features"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 1234"* ]]
  grep -q "TICKET_NUMBER=1234" "$GITHUB_ENV"
}

@test "extracts first ticket number and ignores trailing number in suffix like ak1" {
  export GITHUB_HEAD_REF="ci/1234-add-ticket-to-commit-ak1"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 1234"* ]]
  grep -q "TICKET_NUMBER=1234" "$GITHUB_ENV"
  ! grep -q "TICKET_NUMBER=1" "$GITHUB_ENV" || grep -q "TICKET_NUMBER=1234" "$GITHUB_ENV"
}

@test "shows warning when no ticket number in branch name" {
  export GITHUB_HEAD_REF="feature/add-new-feature"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"No ticket number found in branch name"* ]]
  [ ! -s "$GITHUB_ENV" ]
}
@test "shows warning when branch contains a11y numeronym but no ticket number" {
  export GITHUB_HEAD_REF="fix/a11y-navigation-landmark"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"No ticket number found in branch name"* ]]
  [ ! -s "$GITHUB_ENV" ]
}
@test "shows warning when branch name is empty" {
  export GITHUB_HEAD_REF=""
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"No ticket number found in branch name"* ]]
  [ ! -s "$GITHUB_ENV" ]
}

@test "shows warning when branch name contains only letters" {
  export GITHUB_HEAD_REF="main"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"No ticket number found in branch name"* ]]
  [ ! -s "$GITHUB_ENV" ]
}

@test "extracts ticket number from hotfix branch" {
  export GITHUB_HEAD_REF="hotfix/PROD-9999-critical-bug"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 9999"* ]]
  grep -q "TICKET_NUMBER=9999" "$GITHUB_ENV"
}

@test "extracts ticket number with underscores in branch name" {
  export GITHUB_HEAD_REF="feature/TDN_1713_implement_feature"
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Found ticket number: 1713"* ]]
  grep -q "TICKET_NUMBER=1713" "$GITHUB_ENV"
}
