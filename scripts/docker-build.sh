#!/bin/bash
# Docker build helper script for ape2 project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PLATFORM="linux"
BUILD_TYPE="Release"
DOCKERFILE_DIR=""
IMAGE_NAME=""
CONTAINER_NAME=""
BUILD_DIR="build"
COMPILER="gcc"
ENABLE_SANITIZER=false
SANITIZER_TYPE="address"
RUN_TESTS=false

# Parse command line arguments
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -p, --platform PLATFORM    Platform to build (linux|android|webassembly) [default: linux]"
    echo "  -t, --type BUILD_TYPE      Build type (Debug|Release|FastDebug|SlowRelease) [default: Release]"
    echo "  -c, --compiler COMPILER    Compiler to use (gcc|clang) [default: gcc]"
    echo "  -s, --sanitizer TYPE       Enable sanitizer (address|memory|thread|undefined|leak)"
    echo "  -r, --run-tests            Run tests after building"
    echo "  -h, --help                 Show this help message"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -c|--compiler)
            COMPILER="$2"
            shift 2
            ;;
        -s|--sanitizer)
            ENABLE_SANITIZER=true
            SANITIZER_TYPE="$2"
            shift 2
            ;;
        -r|--run-tests)
            RUN_TESTS=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            usage
            ;;
    esac
done

# Validate platform
case $PLATFORM in
    linux|android|webassembly)
        ;;
    *)
        echo -e "${RED}Error: Invalid platform '$PLATFORM'${NC}"
        usage
        ;;
esac

# Set platform-specific variables
DOCKERFILE_DIR="docker/$PLATFORM"
IMAGE_NAME="ape2-$PLATFORM:latest"
CONTAINER_NAME="ape2-$PLATFORM-build"
BUILD_DIR="build-$PLATFORM-${BUILD_TYPE,,}"

echo -e "${GREEN}Building ape2 for platform: $PLATFORM${NC}"
echo -e "${GREEN}Build type: $BUILD_TYPE${NC}"
echo -e "${GREEN}Compiler: $COMPILER${NC}"

# Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t "$IMAGE_NAME" "$DOCKERFILE_DIR"

# Prepare build directory
mkdir -p "$BUILD_DIR"

# Get current user UID and GID for volume permissions
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Prepare CMake arguments
CMAKE_ARGS="-DCMAKE_BUILD_TYPE=$BUILD_TYPE"

if [ "$COMPILER" = "clang" ]; then
    CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
else
    CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
fi

if [ "$ENABLE_SANITIZER" = true ]; then
    CMAKE_ARGS="$CMAKE_ARGS -DAPE2_ENABLE_SANITIZERS=ON -DAPE2_SANITIZER_TYPE=$SANITIZER_TYPE"
fi

# Check if secrets directory has any files to mount
SECRETS_MOUNT=""
if [ -d "docker/secrets" ] && [ "$(ls -A docker/secrets)" ]; then
    SECRETS_MOUNT="-v $(pwd)/docker/secrets:/secrets:ro"
fi

# Run Docker container for building
echo -e "${YELLOW}Running build in Docker container...${NC}"
docker run --rm \
    --name "$CONTAINER_NAME" \
    -v "$(pwd):/workspace" \
    -v "$(pwd)/$BUILD_DIR:/build" \
    $SECRETS_MOUNT \
    -w /workspace \
    -e "CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)" \
    "$IMAGE_NAME" \
    bash -c "
        cmake -B /build -S /workspace -G Ninja $CMAKE_ARGS && \
        cmake --build /build --parallel
    "

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build completed successfully!${NC}"

    # Run tests if requested
    if [ "$RUN_TESTS" = true ]; then
        echo -e "${YELLOW}Running tests...${NC}"
        docker run --rm \
            -v "$(pwd):/workspace" \
            -v "$(pwd)/$BUILD_DIR:/build" \
            -w /build \
            "$IMAGE_NAME" \
            bash -c "ctest --output-on-failure"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}All tests passed!${NC}"
        else
            echo -e "${RED}Some tests failed!${NC}"
            exit 1
        fi
    fi
else
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

