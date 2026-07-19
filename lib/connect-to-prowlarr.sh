#!/usr/bin/env bash
# This scrpt tells prowlarr a downstrean media app lives so it can sync indexers
set -euo pipefail

export PATH="@scriptPath@:$PATH"
PROWLARR_URL="http://127.0.0.1:@prowlarrPort@"
SUB_APP_URL="http://127.0.0.1:@subAppPort@"
SUB_APP_NAME="@subAppName@" # e.g., "Lidarr", "Sonarr", "Radarr"

source "@prowlarrEnvPath@"
source "@subAppEnvPath@"

PROWLARR_KEY="$PROWLARR__AUTH__APIKEY"

# Convert service to upper
SERVICE_PREFIX="${SUB_APP_NAME^^}"
# Built key variable with name string
ENV_VAR_NAME="${SERVICE_PREFIX}__AUTH__APIKEY"
# Indirectly expand it to get the token
SUB_APP_KEY="${!ENV_VAR_NAME}"

echo "Waiting for Prowlarr web engine..."
while true; do
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$PROWLARR_URL/api/v1/system/status?apiKey=$PROWLARR_KEY" || echo "000")
  if [ "$STATUS_CODE" = "200" ]; then
    break
  fi
  sleep 2
done

echo "Checking if $SUB_APP_NAME is registered in Prowlarr..."
APPS_RESPONSE=$(curl -s -w "\n%{http_code}" -H "X-Api-Key: $PROWLARR_KEY" "$PROWLARR_URL/api/v1/applications")
APPS_STATUS="${APPS_RESPONSE##*$'\n'}"
APPS_BODY="${APPS_RESPONSE%$'\n'*}"
if [ "$APPS_STATUS" != "200" ]; then
  echo "ERROR: Failed to list Prowlarr applications (HTTP $APPS_STATUS): $APPS_BODY" >&2
  exit 1
fi

if ! echo "$APPS_BODY" | grep -q "$SUB_APP_NAME"; then
  echo "Linking $SUB_APP_NAME target profile..."
  PAYLOAD=$(cat <<EOF
{
  "name": "$SUB_APP_NAME",
  "implementation": "$SUB_APP_NAME",
  "configContract": "${SUB_APP_NAME}Settings",
  "syncLevel": "fullSync",
  "fields": [
    {"name": "prowlarrUrl", "value": "$PROWLARR_URL"},
    {"name": "baseUrl", "value": "$SUB_APP_URL"},
    {"name": "apiKey", "value": "$SUB_APP_KEY"}
  ]
}
EOF
)
  POST_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -H "X-Api-Key: $PROWLARR_KEY" -d "$PAYLOAD" "$PROWLARR_URL/api/v1/applications")
  POST_STATUS="${POST_RESPONSE##*$'\n'}"
  POST_BODY="${POST_RESPONSE%$'\n'*}"
  echo "Prowlarr application registration response (HTTP $POST_STATUS): $POST_BODY"
  if [ "$POST_STATUS" != "200" ] && [ "$POST_STATUS" != "201" ]; then
    echo "ERROR: Failed to register $SUB_APP_NAME with Prowlarr (HTTP $POST_STATUS)" >&2
    exit 1
  fi
fi
