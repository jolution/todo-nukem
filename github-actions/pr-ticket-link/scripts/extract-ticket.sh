#!/bin/bash
set -e

BRANCH_NAME="${GITHUB_HEAD_REF:-}"
TICKET_NUMBER=$(echo "$BRANCH_NAME" | grep -oE '[0-9]+' || true)

if [ -z "$TICKET_NUMBER" ]; then
  echo "⚠️ No ticket number found in branch name"
  exit 0
fi

echo "🎫 Found ticket number: $TICKET_NUMBER"
echo "TICKET_NUMBER=$TICKET_NUMBER" >> "$GITHUB_ENV"
