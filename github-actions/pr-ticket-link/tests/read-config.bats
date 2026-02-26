#!/usr/bin/env bats

SCRIPT_PATH="${BATS_TEST_DIRNAME}/../scripts/read-config.sh"

setup() {
  export GITHUB_ENV=$(mktemp)
  export TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
}

teardown() {
  rm -rf "$TEST_DIR" "$GITHUB_ENV"
}

@test "reads ticketBaseUrl from .todonukem-local.json" {
  echo '{"ticketBaseUrl": "https://local.example.com/"}' > .todonukem-local.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from .todonukem-local.json"* ]]
  grep -q "TICKET_BASE_URL=https://local.example.com/" "$GITHUB_ENV"
}

@test "reads ticketBaseUrl from .todonukem.json" {
  echo '{"ticketBaseUrl": "https://example.com/"}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from .todonukem.json"* ]]
  grep -q "TICKET_BASE_URL=https://example.com/" "$GITHUB_ENV"
}

@test "reads ticketBaseUrl from package.json" {
  echo '{"todonukem": {"ticketBaseUrl": "https://pkg.example.com/"}}' > package.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from package.json"* ]]
  grep -q "TICKET_BASE_URL=https://pkg.example.com/" "$GITHUB_ENV"
}

@test "prefers .todonukem-local.json over .todonukem.json" {
  echo '{"ticketBaseUrl": "https://local.example.com/"}' > .todonukem-local.json
  echo '{"ticketBaseUrl": "https://regular.example.com/"}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from .todonukem-local.json"* ]]
  grep -q "TICKET_BASE_URL=https://local.example.com/" "$GITHUB_ENV"
}

@test "prefers .todonukem.json over package.json" {
  echo '{"ticketBaseUrl": "https://todonukem.example.com/"}' > .todonukem.json
  echo '{"todonukem": {"ticketBaseUrl": "https://pkg.example.com/"}}' > package.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from .todonukem.json"* ]]
  grep -q "TICKET_BASE_URL=https://todonukem.example.com/" "$GITHUB_ENV"
}

@test "shows warning when no config file exists" {
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Warning: ticketBaseUrl not found"* ]]
  [[ "$output" == *".todonukem-local.json .todonukem.json package.json"* ]]
}

@test "shows warning when ticketBaseUrl is empty in config" {
  echo '{"ticketBaseUrl": ""}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Warning: ticketBaseUrl not found"* ]]
}

@test "shows warning when ticketBaseUrl is null in config" {
  echo '{"ticketBaseUrl": null}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Warning: ticketBaseUrl not found"* ]]
}

@test "skips config file when ticketBaseUrl field is missing" {
  echo '{"otherField": "value"}' > .todonukem.json
  echo '{"todonukem": {"ticketBaseUrl": "https://pkg.example.com/"}}' > package.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from package.json"* ]]
  grep -q "TICKET_BASE_URL=https://pkg.example.com/" "$GITHUB_ENV"
}

@test "reads optional ticketPrefix from config" {
  echo '{"ticketBaseUrl": "https://example.com/", "ticketPrefix": "AB#"}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using ticketBaseUrl from .todonukem.json"* ]]
  grep -q "TICKET_BASE_URL=https://example.com/" "$GITHUB_ENV"
  grep -q "TICKET_PREFIX=AB#" "$GITHUB_ENV"
}

@test "works without ticketPrefix" {
  echo '{"ticketBaseUrl": "https://example.com/"}' > .todonukem.json
  
  run bash "$SCRIPT_PATH"
  
  [ "$status" -eq 0 ]
  grep -q "TICKET_BASE_URL=https://example.com/" "$GITHUB_ENV"
  ! grep -q "TICKET_PREFIX" "$GITHUB_ENV"
}
