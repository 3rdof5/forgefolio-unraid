#!/usr/bin/env bash
# Forgefolio's command-line update cycle for Unraid: pull, compare, recreate.
#
# The container config below mirrors the distribution template with the
# owner's values baked in (port, models share, account). If a release notes
# new template fields, add them here — or run the web UI's Update Container
# once, which always reads the saved template.
#
# Usage:
#   bash update-forgefolio.sh          # pull + update when a newer image exists
#   bash update-forgefolio.sh check    # report only, touch nothing
set -euo pipefail

CONTAINER=Forgefolio
IMAGE=ghcr.io/3rdof5/forgefolio:latest
WEB_URL="http://192.168.199.4:3567"   # the address you browse the app at

MODE="${1:-update}"

echo "Pulling $IMAGE…"
docker pull "$IMAGE" >/dev/null

RUNNING_IMAGE=$(docker inspect "$CONTAINER" --format '{{.Image}}' 2>/dev/null || echo missing)
LATEST_IMAGE=$(docker inspect "$IMAGE" --format '{{.Id}}')

if [ "$RUNNING_IMAGE" = "$LATEST_IMAGE" ]; then
  echo "Forgefolio is already up to date ($WEB_URL)."
  exit 0
fi

if [ "$MODE" = "check" ]; then
  echo "A newer image is available — run without 'check' to apply it."
  exit 0
fi

echo "A newer image is available — recreating the container."
echo "(Your data lives on the bind mounts: /config and /models are never touched.)"

docker rm -f "$CONTAINER" >/dev/null

docker run -d --name "$CONTAINER" \
  --restart unless-stopped \
  -p 3567:80 \
  -v /mnt/user/appdata/forgefolio:/config \
  -v /mnt/user/threedmodels:/models \
  -e PUID=99 \
  -e PGID=100 \
  -e UMASK=022 \
  -e UPLOAD_DIR=/models \
  -e UPLOAD_MAX_BYTES=1073741824 \
  -e COOKIE_SECURE=false \
  "$IMAGE"

echo "Forgefolio updated — $WEB_URL"
echo "First boot runs the library sweeps; give the health check a few seconds."
