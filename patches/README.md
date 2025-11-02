# Patches Directory

This directory contains patches for third-party libraries to support multiple platforms.

## Structure

Organize patches by library name:

```
patches/
├── boost/
│   ├── 0001-fix-windows-build.patch
│   └── 0002-fix-arm64-support.patch
├── zlib/
│   └── 0001-cmake-improvements.patch
└── README.md
```

## How to Apply Patches

Patches are automatically applied by the CMake build system using the `apply_patch` function defined in `cmake/modules/ThirdParty.cmake`.

Example in CMakeLists.txt:

```cmake
FetchContent_Declare(
    some_library
    GIT_REPOSITORY https://github.com/example/library.git
    GIT_TAG v1.0.0
)

FetchContent_MakeAvailable(some_library)

# Apply patches
apply_patch(some_library "0001-fix-windows-build.patch")
```

## Creating Patches

To create a patch for a library:

1. Clone the library repository
2. Make your changes
3. Create a patch file:
   ```bash
   git diff > 0001-description.patch
   ```
4. Move the patch to the appropriate subdirectory

## Patch Naming Convention

Use the format: `NNNN-description.patch`

- `NNNN`: Four-digit sequential number (0001, 0002, etc.)
- `description`: Brief description using kebab-case
- `.patch`: Extension

Examples:
- `0001-fix-windows-build.patch`
- `0002-add-arm64-support.patch`
- `0003-improve-cmake-config.patch`

