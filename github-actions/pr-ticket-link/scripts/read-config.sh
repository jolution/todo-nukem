#!/bin/bash
set -e

# Try config files in the following order
CONFIG_FILES=(".todonukem-local.json" ".todonukem.json" "package.json")

for FILE in "${CONFIG_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    # Use different jq path for package.json
    if [ "$FILE" = "package.json" ]; then
      TICKET_BASE_URL=$(jq -r '.todonukem.ticketBaseUrl // empty' "$FILE")
      TICKET_PREFIX=$(jq -r '.todonukem.ticketPrefix // empty' "$FILE")
    else
      TICKET_BASE_URL=$(jq -r '.ticketBaseUrl // empty' "$FILE")
      TICKET_PREFIX=$(jq -r '.ticketPrefix // empty' "$FILE")
    fi
    
    if [ -n "$TICKET_BASE_URL" ]; then
      echo "✅ Using ticketBaseUrl from $FILE"
      echo "TICKET_BASE_URL=$TICKET_BASE_URL" >> "$GITHUB_ENV"
      
      # Optional: add ticketPrefix if present
      if [ -n "$TICKET_PREFIX" ]; then
        echo "TICKET_PREFIX=$TICKET_PREFIX" >> "$GITHUB_ENV"
      fi
      
      exit 0
    fi
  fi
done

echo "⚠️ Warning: ticketBaseUrl not found in ${CONFIG_FILES[*]}"
echo "Skipping ticket link addition. Configure ticketBaseUrl in one of these files to enable this feature."
exit 0
