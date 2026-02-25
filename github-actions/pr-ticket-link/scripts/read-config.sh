#!/bin/bash
set -e

# Try config files in the following order
CONFIG_FILES=(".todonukem-local.json" ".todonukem.json" "package.json")

for FILE in "${CONFIG_FILES[@]}"; do
  if [ -f "$FILE" ]; then
    # Use different jq path for package.json
    CONFIG_PATH=$( [ "$FILE" = "package.json" ] && echo ".todonukem.ticketBaseUrl" || echo ".ticketBaseUrl" )
    TICKET_BASE_URL=$(jq -r "${CONFIG_PATH} // empty" "$FILE")
    if [ -n "$TICKET_BASE_URL" ]; then
      echo "✅ Using ticketBaseUrl from $FILE"
      echo "TICKET_BASE_URL=$TICKET_BASE_URL" >> "$GITHUB_ENV"
      exit 0
    fi
  fi
done

echo "⚠️ Warning: ticketBaseUrl not found in ${CONFIG_FILES[*]}"
echo "Skipping ticket link addition. Configure ticketBaseUrl in one of these files to enable this feature."
exit 0
