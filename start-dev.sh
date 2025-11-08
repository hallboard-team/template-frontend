#!/bin/bash
# -----------------------------
# Start Podman Compose for Angular dev environment
# Usage:
#   ./start-dev.sh <container-name> <port> <node version> <angular version>
# Example:
#   ./start-dev.sh angular-pnpm 4200 22 19
# -----------------------------

set -euo pipefail
cd "$(dirname "$0")"

CUSTOM_NAME="${1:-}"
PORT="${2:-4200}"
NODE_VERSION="${3:-22}"
ANGULAR_VERSION="${4:-20}"

# Build container name dynamically
if [ -z "$CUSTOM_NAME" ]; then
  CONTAINER_NAME="frontend_angular${ANGULAR_VERSION}_dev"
else
  CONTAINER_NAME="${CUSTOM_NAME}_angular${ANGULAR_VERSION}_dev"
fi

# Fix VS Code shared cache permissions
sudo rm -rf ~/.cache/vscode-server-shared
mkdir -p ~/.cache/vscode-server-shared/bin
sudo chown -R 1000:1000 ~/.cache/vscode-server-shared

echo "🚀 Building & starting Angular container '$CONTAINER_NAME' (Node $NODE_VERSION, Angular $ANGULAR_VERSION, port $PORT)..."

if CONTAINER_NAME="$CONTAINER_NAME" PORT="$PORT" NODE_VERSION="$NODE_VERSION" ANGULAR_VERSION="$ANGULAR_VERSION" \
   podman-compose -f podman-compose.frontend.yml up -d --build; then
  echo "✅ Container '$CONTAINER_NAME' started successfully (Node $NODE_VERSION, Angular $ANGULAR_VERSION) on port $PORT"
else
  echo "❌ Failed to start container '$CONTAINER_NAME' (Node $NODE_VERSION, Angular $ANGULAR_VERSION)"
  exit 1
fi
