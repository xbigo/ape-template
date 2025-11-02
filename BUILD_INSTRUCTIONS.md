# Build Instructions

This document provides detailed instructions for building the ape2 project on different platforms.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Platform-Specific Instructions](#platform-specific-instructions)
  - [Windows](#windows)
  - [Linux](#linux)
  - [macOS](#macos)
  - [Android](#android)
  - [iOS](#ios)
  - [WebAssembly](#webassembly)
- [Build Options](#build-options)
- [Docker Builds](#docker-builds)
- [Testing](#testing)
- [Documentation](#documentation)

## Prerequisites

### Common Requirements

- CMake 3.28 or later
- C++23 capable compiler with full C++ modules support:
  - Clang 19.1+
  - GCC 15.2+
  - MSVC 19.42+ (Visual Studio 2022 17.12+)
- Ninja build system (recommended)

### Optional Tools

- Doxygen (for documentation)
- clang-format (for code formatting)
- clang-tidy (for static analysis)
- lcov/gcovr (for code coverage)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/xbigo/ape2.git
cd ape2

# Configure
cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja

# Build
cmake --build build --parallel

# Test
cd build && ctest --output-on-failure
```

## Platform-Specific Instructions

### Windows

#### Using Visual Studio

```powershell
# Configure
cmake -B build -G "Visual Studio 17 2022" -A x64

# Build
cmake --build build --config Release

# Or open the solution in Visual Studio
start build\ape2.sln
```

#### Using Ninja

```powershell
# Open Visual Studio Developer Command Prompt
# Then run:
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
```

### Linux

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y build-essential cmake ninja-build

# With GCC
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
cmake --build build --parallel

# With Clang
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build build --parallel
```

### macOS

```bash
# Install dependencies
brew install cmake ninja

# Build
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel

# Or with Xcode
cmake -B build -G Xcode
open build/ape2.xcodeproj
```

### Android

Requires Android NDK 26+.

```bash
# Set NDK path
export ANDROID_NDK=/path/to/ndk

# Configure for arm64-v8a
cmake -B build-android -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build-android --parallel
```

### iOS

Requires Xcode.

```bash
# Configure for iOS device
cmake -B build-ios -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0

# Build
cmake --build build-ios --config Release

# Or for iOS Simulator
cmake -B build-ios-sim -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_ARCHITECTURES=x86_64 \
    -DCMAKE_OSX_SYSROOT=iphonesimulator
```

### WebAssembly

Requires Emscripten SDK.

```bash
# Install and activate Emscripten
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# Configure
emcmake cmake -B build-wasm -G Ninja -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build-wasm --parallel
```

## Build Options

### Build Types

- `Debug` - No optimization, full debug info
- `Release` - Full optimization, minimal debug info
- `FastDebug` - Light optimization (O1), full debug info
- `SlowRelease` - No optimization (O0), Release settings
- `RelWithDebInfo` - Optimized with debug info
- `MinSizeRel` - Optimized for size

### CMake Options

```bash
# Enable/disable features
-DAPE2_BUILD_TESTS=ON              # Build tests (default: ON)
-DAPE2_BUILD_UNIT_TESTS=ON         # Build unit tests (default: ON)
-DAPE2_BUILD_REGRESSION_TESTS=ON   # Build regression tests (default: ON)
-DAPE2_BUILD_FUZZ_TESTS=OFF        # Build fuzz tests (default: OFF)
-DAPE2_BUILD_BENCHMARKS=ON         # Build benchmarks (default: ON)
-DAPE2_BUILD_DOCS=OFF              # Build documentation (default: OFF)

# Code quality
-DAPE2_ENABLE_COVERAGE=OFF         # Enable code coverage (default: OFF)
-DAPE2_ENABLE_CLANG_TIDY=ON        # Enable clang-tidy (default: ON)

# Sanitizers
-DAPE2_ENABLE_SANITIZERS=OFF       # Enable sanitizers (default: OFF)
-DAPE2_SANITIZER_TYPE=address      # Sanitizer type (address|memory|thread|undefined)

# Build options
-DAPE2_STRIP_SYMBOLS=OFF           # Strip symbols from libraries (default: OFF)
-DAPE2_ENABLE_DISTRIBUTED_BUILD=OFF # Enable distributed build (default: OFF)
-DAPE2_USE_MODULES=ON              # Enable C++ modules (default: ON)
-DAPE2_INSTALL=ON                  # Enable install target (default: ON)

# Package manager
-DAPE2_PACKAGE_MANAGER=conan       # Package manager (conan|vcpkg|none)
```

### Example Configurations

```bash
# Debug build with sanitizers
cmake -B build-debug -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DAPE2_ENABLE_SANITIZERS=ON \
    -DAPE2_SANITIZER_TYPE=address

# Release build with tests and coverage
cmake -B build-coverage -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DAPE2_ENABLE_COVERAGE=ON

# Minimal release build (no tests)
cmake -B build-minimal -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DAPE2_BUILD_TESTS=OFF \
    -DAPE2_STRIP_SYMBOLS=ON
```

## Docker Builds

### Linux

```bash
# Using the provided script (Unix)
bash scripts/docker-build.sh -p linux -t Release -r

# Using the provided script (Windows)
powershell scripts/docker-build.ps1 -Platform linux -BuildType Release -RunTests

# Manual Docker build
docker build -t ape2-linux docker/linux
docker run --rm -v $(pwd):/workspace -w /workspace ape2-linux \
    bash -c "cmake -B /build -G Ninja && cmake --build /build"
```

### Android

```bash
bash scripts/docker-build.sh -p android -t Release
```

### WebAssembly

```bash
bash scripts/docker-build.sh -p webassembly -t Release
```

### Interactive Docker Shell

```bash
# Open shell in Docker container
bash scripts/docker-shell.sh linux
```

## Testing

```bash
# Run all tests
cd build
ctest --output-on-failure

# Run specific test labels
ctest -L unit                  # Unit tests only
ctest -L regression            # Regression tests only

# Run tests with verbose output
ctest -V

# Run tests in parallel
ctest -j$(nproc)

# Generate coverage report (Linux/macOS)
cmake --build build --target coverage
```

## Documentation

```bash
# Generate documentation with Doxygen
cmake -B build -DAPE2_BUILD_DOCS=ON
cmake --build build --target doc

# View documentation
open build/docs/html/index.html  # macOS
xdg-open build/docs/html/index.html  # Linux
start build/docs/html/index.html  # Windows
```

## Troubleshooting

### CMake can't find compiler

Set the compiler explicitly:

```bash
cmake -B build -DCMAKE_C_COMPILER=/path/to/gcc \
               -DCMAKE_CXX_COMPILER=/path/to/g++
```

### Ninja not found

Install Ninja or use another generator:

```bash
# Use Make instead
cmake -B build -G "Unix Makefiles"

# Or install Ninja
# Ubuntu/Debian
sudo apt-get install ninja-build

# macOS
brew install ninja

# Windows
choco install ninja
```

### C++23 features not available

Update your compiler to a version that supports C++23 with full C++ modules:
- Clang 19.1 or later
- GCC 15.2 or later
- MSVC 19.42 or later (Visual Studio 2022 17.12+)

### Tests fail with sanitizer enabled

Some sanitizers have known incompatibilities. Try different sanitizers:

```bash
# Try different sanitizers
cmake -B build -DAPE2_ENABLE_SANITIZERS=ON -DAPE2_SANITIZER_TYPE=undefined
```

## Support

For issues and questions:
- Open an issue on GitHub
- Check existing documentation
- Review the README.md file

