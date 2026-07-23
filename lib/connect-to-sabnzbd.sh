#!/usr/bin/env bash
# This script connects any indexer to SABnzbd
set -euo pipefail

export PATH="@scriptPath@:$PATH"
TARGET_APP_URL="http://127.0.0.1:@targetAppPort@"
DOWNLOADER_PORT="@downloaderPort@"
# e.g., "musicCategory", "tvCategory", or "none" for Prowlarr
CAT_NAME="@categoryName@"
# e.g., "music", "tv", or ""
CAT_VAL="@categoryValue@"
SERVICE_NAME="@serviceName@"

source "@targetAppEnvPath@"
DOWNLOADER_KEY=$(sed -n 's/^api_key\s*=\s*\(.*\)/\1/p' "@downloaderSecretsPath@")

# Extract whichever API key variable belongs to the target app booting up
ENV_VAR_NAME="${SERVICE_NAME}__AUTH__APIKEY"
APP_KEY="${!ENV_VAR_NAME}"

echo "Waiting for service to respond at $TARGET_APP_URL..."
while true; do
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET_APP_URL/api/v1/system/status?apiKey=$APP_KEY" || echo "000")
  if [ "$STATUS_CODE" = "200" ]; then
    break
  fi
  sleep 2
done

echo "Checking if downloader link exists..."
DC_RESPONSE=$(curl -s -w "\n%{http_code}" -H "X-Api-Key: $APP_KEY" "$TARGET_APP_URL/api/v1/downloadclient")
DC_STATUS="${DC_RESPONSE##*$'\n'}"
DC_BODY="${DC_RESPONSE%$'\n'*}"
if [ "$DC_STATUS" != "200" ]; then
  echo "ERROR: Failed to list download clients on $SERVICE_NAME (HTTP $DC_STATUS): $DC_BODY" >&2
  exit 1
fi

if ! echo "$DC_BODY" | grep -q "SABnzbd"; then
  echo "Registering SABnzbd download client..."
  
  FIELDS="[{\"name\": \"host\", \"value\": \"127.0.0.1\"}, {\"name\": \"port\", \"value\": $DOWNLOADER_PORT}, {\"name\": \"apiKey\", \"value\": \"$DOWNLOADER_KEY\"}"
  if [ "$CAT_NAME" != "none" ]; then
    FIELDS="$FIELDS, {\"name\": \"$CAT_NAME\", \"value\": \"$CAT_VAL\"}"
  fi
  FIELDS="$FIELDS]"

  PAYLOAD=$(cat <<EOF
{
  "enable": true,
  "priority": 1,
  "name": "SABnzbd",
  "implementation": "Sabnzbd",
  "configContract": "SabnzbdSettings",
  "fields": $FIELDS
}
EOF
)

  POST_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -H "X-Api-Key: $APP_KEY" -d "$PAYLOAD" "$TARGET_APP_URL/api/v1/downloadclient")
  POST_STATUS="${POST_RESPONSE##*$'\n'}"
  POST_BODY="${POST_RESPONSE%$'\n'*}"
  echo "SABnzbd registration response (HTTP $POST_STATUS): $POST_BODY"
  if [ "$POST_STATUS" != "200" ] && [ "$POST_STATUS" != "201" ]; then
    echo "ERROR: Failed to register SABnzbd with $SERVICE_NAME (HTTP $POST_STATUS)" >&2
    exit 1
  fi
fi
