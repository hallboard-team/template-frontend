#!/bin/bash
# -----------------------------
# Build & Start Podman Compose for Angular dev environment
# Usage:
#   ./pull-build-start-dev.sh <port> [node_version] [angular_version]
# Example:
#   ./pull-build-start-dev.sh 4200 22 20
# -----------------------------

set -euo pipefail
cd "$(dirname "$0")"

PORT="${1:-4200}"
NODE_VERSION="${2:-22}"
ANGULAR_VERSION="${3:-20}"
IMAGE="ghcr.io/hallboard-team/node-v${NODE_VERSION}_angular-v${ANGULAR_VERSION}:latest"
CONTAINER_NAME="frontend_node-v${NODE_VERSION}_angular-v${ANGULAR_VERSION}_pnpm_p${PORT}_dev"
COMPOSE_FILE="../podman-compose.frontend.yml"

# Fix VS Code shared cache permissions
sudo rm -rf ~/.cache/vscode-server-shared
mkdir -p ~/.cache/vscode-server-shared/bin
sudo chown -R 1000:1000 ~/.cache/vscode-server-shared

# Check if image already exists locally
if podman image exists "$IMAGE"; then
  echo "🧱 Image '$IMAGE' already exists locally — skipping build."
else
  echo "🏗️  Image '$IMAGE' not found — building now..."
fi

echo "🚀 Building & starting Angular container '$CONTAINER_NAME' (Node $NODE_VERSION, Angular $ANGULAR_VERSION, port $PORT)..."

# Run build+start
if CONTAINER_NAME="$CONTAINER_NAME" PORT="$PORT" NODE_VERSION="$NODE_VERSION" ANGULAR_VERSION="$ANGULAR_VERSION" \
   podman-compose -f "$COMPOSE_FILE" up -d --build; then

  # Verify the container is actually running
  if podman ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
    echo "✅ Container '$CONTAINER_NAME' started successfully (Node $NODE_VERSION, Angular $ANGULAR_VERSION) on port $PORT"
  else
    echo "❌ Container '$CONTAINER_NAME' did not start properly even though compose succeeded."
    exit 1
  fi
else
  echo "❌ podman-compose failed to build or start container '$CONTAINER_NAME'."
  exit 1
fi
