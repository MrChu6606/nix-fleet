#!/usr/bin/env bash
# This scrpt tells prowlarr a downstrean media app lives so it can sync indexers
set -euo pipefail

PROWLARR_URL="http://127.0.0.1:@prowlarrPort@"
SUB_APP_URL="http://127.0.0.1:@subAppPort@"
SUB_APP_NAME="@subAppName@" # e.g., "Lidarr", "Sonarr", "Radarr"

source "@prowlarrEnvPath@"
source "@subAppEnvPath@"

PROWLARR_KEY="$PROWLARR__SERVER__APIKEY"
# Dynamically pull the correct child key depending on which app we are linking
SUB_APP_KEY="${LIDARR__SERVER__APIKEY:-${SONARR__SERVER__APIKEY:-$RADARR__SERVER__APIKEY}}"

echo "Waiting for Prowlarr web engine..."
until curl -s -o /dev/null -w "%{http_code}" "$PROWLARR_URL/api/v1/system/status?apiKey=$PROWLARR_KEY" | grep -q "200"; do
  sleep 2
done

echo "Checking if $SUB_APP_NAME is registered in Prowlarr..."
if ! curl -s -H "X-Api-Key: $PROWLARR_KEY" "$PROWLARR_URL/api/v1/applications" | grep -q "$SUB_APP_NAME"; then
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
  curl -s -X POST -H "Content-Type: application/json" -H "X-Api-Key: $PROWLARR_KEY" -d "$PAYLOAD" "$PROWLARR_URL/api/v1/applications"
fi
