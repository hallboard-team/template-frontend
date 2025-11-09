#!/bin/bash
# -----------------------------
# Start Podman Compose for Angular dev environment (shared stack)
# Usage:
#   ./pull-start-dev.sh <port> [node_version]
# Example:
#   ./pull-start-dev.sh 4300 22
# -----------------------------

set -euo pipefail
cd "$(dirname "$0")"

PORT="${1:-4200}"
NODE_VERSION="${2:-22}"
ANGULAR_VERSION="20"  # Fixed for this image generation cycle
IMAGE="ghcr.io/hallboard-team/node-v${NODE_VERSION}_angular-v${ANGULAR_VERSION}:latest"
CONTAINER_NAME="frontend_node-v${NODE_VERSION}_angular-v${ANGULAR_VERSION}_pnpm_p${PORT}_dev"

# Fix VS Code shared cache permissions
sudo rm -rf ~/.cache/vscode-server-shared
mkdir -p ~/.cache/vscode-server-shared/bin
sudo chown -R 1000:1000 ~/.cache/vscode-server-shared

# Check if the port is already in use
if ss -tuln | grep -q ":${PORT} "; then
  echo "⚠️  Port ${PORT} is already in use. Please choose another port."
  exit 1
fi

echo "🔍 Checking for image: $IMAGE"

# Pull image manually and verify success
if ! podman pull "$IMAGE"; then
  echo "❌ Failed to pull image '$IMAGE'. Ensure it exists on GHCR."
  exit 1
fi

echo "🚀 Starting Angular container '$CONTAINER_NAME' (Node $NODE_VERSION, Angular $ANGULAR_VERSION, port $PORT)..."

# Start container without building
if CONTAINER_NAME="$CONTAINER_NAME" PORT="$PORT" NODE_VERSION="$NODE_VERSION" ANGULAR_VERSION="$ANGULAR_VERSION" \
   podman-compose -f podman-compose.frontend.yml up -d; then

  # Verify the container is running
  if podman ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
    echo "✅ Container '$CONTAINER_NAME' started successfully (Node $NODE_VERSION, Angular $ANGULAR_VERSION) on port $PORT"
  else
    echo "❌ Container '$CONTAINER_NAME' did not start properly even though compose succeeded."
    exit 1
  fi

else
  echo "❌ podman-compose failed to start container '$CONTAINER_NAME'."
  exit 1
fi
