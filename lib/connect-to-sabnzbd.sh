#!/usr/bin/env bash
# This script connects any indexer to SABnzbd
set -euo pipefail

TARGET_APP_URL="http://127.0.0.1:@targetAppPort@"
DOWNLOADER_PORT="@downloaderPort@"
# e.g., "musicCategory", "tvCategory", or "none" for Prowlarr
CAT_NAME="@categoryName@"
# e.g., "music", "tv", or ""
CAT_VAL="@categoryValue@"
source "@targetAppEnvPath@"
DOWNLOADER_KEY=$(sed -n 's/^api_key\s*=\s*\(.*\)/\1/p' "@downloaderSecretsPath@")

# Extract whichever API key variable belongs to the target app booting up
APP_KEY="${PROWLARR__SERVER__APIKEY:-${LIDARR__SERVER__APIKEY:-${SONARR__SERVER__APIKEY:-$RADARR__SERVER__APIKEY}}}"

echo "Waiting for service to respond at $TARGET_APP_URL..."
until curl -s -o /dev/null -w "%{http_code}" "$TARGET_APP_URL/api/v1/system/status?apiKey=$APP_KEY" | grep -q "200"; do
  sleep 2
done

echo "Checking if downloader link exists..."
if ! curl -s -H "X-Api-Key: $APP_KEY" "$TARGET_APP_URL/api/v1/downloadclient" | grep -q "SABnzbd"; then
  echo "Registering SABnzbd download client..."
  
  # Build a flexible JSON block that only adds categories if they are specified
  FIELDS="[{\"name\": \"host\", \"value\": \"127.0.0.1\"}, {\"name\": \"port\", \"value\": $DOWNLOADER_PORT}, {\"name\": \"apiKey\", \"value\": \"$DOWNLOADER_KEY\"}"
  if [ "$CAT_NAME" != "none" ]; then
    FIELDS="$FIELDS, {\"name\": \"$CAT_NAME\", \"value\": \"$CAT_VAL\"}"
  fi
  FIELDS="$FIELDS]"

  PAYLOAD=$(cat <<EOF
{
  "enable": true,
  "name": "SABnzbd",
  "implementation": "Sabnzbd",
  "configContract": "SabnzbdSettings",
  "fields": $FIELDS
}
EOF
)

  curl -s -X POST -H "Content-Type: application/json" -H "X-Api-Key: $APP_KEY" -d "$PAYLOAD" "$TARGET_APP_URL/api/v1/downloadclient"
fi
