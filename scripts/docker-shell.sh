#!/bin/bash
# Interactive shell in Docker container

set -e

# Default platform
PLATFORM="linux"

# Parse arguments
if [ $# -gt 0 ]; then
    PLATFORM="$1"
fi

# Validate platform
case $PLATFORM in
    linux|android|webassembly)
        ;;
    *)
        echo "Usage: $0 [linux|android|webassembly]"
        echo "Default: linux"
        exit 1
        ;;
esac

IMAGE_NAME="ape2-$PLATFORM:latest"
CONTAINER_NAME="ape2-$PLATFORM-shell"

# Build image if it doesn't exist
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Image $IMAGE_NAME not found. Building..."
    docker build -t "$IMAGE_NAME" "docker/$PLATFORM"
fi

# Check if secrets directory has any files to mount
SECRETS_MOUNT=""
if [ -d "docker/secrets" ] && [ "$(ls -A docker/secrets)" ]; then
    SECRETS_MOUNT="-v $(pwd)/docker/secrets:/secrets:ro"
fi

echo "Starting interactive shell in $PLATFORM container..."
echo "Workspace: $(pwd)"
echo ""

docker run --rm -it \
    --name "$CONTAINER_NAME" \
    -v "$(pwd):/workspace" \
    $SECRETS_MOUNT \
    -w /workspace \
    "$IMAGE_NAME" \
    bash

