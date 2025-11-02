# Compiler Version Requirements

This document details the compiler version requirements for the ape-template project.

## 📋 Minimum Version Requirements

To fully leverage C++23 features, especially complete C++ module support, this project requires the following compiler versions:

| Compiler | Minimum Version | Corresponding IDE/Distribution | Notes |
|----------|----------------|-------------------------------|-------|
| **Clang** | 19.1 | LLVM 19.1+ | Full C++23 and module support |
| **GCC** | 15.2 | GCC 15.2+ | Full C++23 and module support |
| **MSVC** | 19.42 | Visual Studio 2022 17.12+ | Full C++23 and module support |

## 🎯 Why These Versions?

### Clang 19.1+
- ✅ Complete C++23 standard support
- ✅ Stable C++ module implementation
- ✅ Improved standard library module support
- ✅ Better diagnostics and error messages
- ✅ Optimized module compilation performance

### GCC 15.2+
- ✅ Complete C++23 standard support
- ✅ Production-grade C++ module implementation
- ✅ Full standard library module support
- ✅ Improved module compilation speed
- ✅ Better ABI stability

### MSVC 19.42+ (Visual Studio 2022 17.12+)
- ✅ Complete C++23 standard support
- ✅ Stable C++ module implementation
- ✅ Full standard library module support
- ✅ Deep integration with Visual Studio IDE
- ✅ Excellent debugging experience

## 🔍 Feature Comparison

### C++23 Feature Support

| Feature | Clang 19.1 | GCC 15.2 | MSVC 19.42 |
|---------|-----------|---------|-----------|
| Modules | ✅ | ✅ | ✅ |
| `import std` | ✅ | ✅ | ✅ |
| Deducing this | ✅ | ✅ | ✅ |
| `if consteval` | ✅ | ✅ | ✅ |
| Multidimensional subscript | ✅ | ✅ | ✅ |
| `static operator()` | ✅ | ✅ | ✅ |
| `auto(x)` | ✅ | ✅ | ✅ |
| Ranges improvements | ✅ | ✅ | ✅ |
| `std::expected` | ✅ | ✅ | ✅ |
| `std::mdspan` | ✅ | ✅ | ✅ |

## 📦 Obtaining Compilers

### Clang 19.1+

**Linux (Ubuntu/Debian):**
```bash
# Add LLVM repository
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main"

# Install
sudo apt-get update
sudo apt-get install clang-19 clang++-19
```

**macOS:**
```bash
# Using Homebrew
brew install llvm@19
```

**Windows:**
- Download and install [LLVM 19.1+](https://releases.llvm.org/)

### GCC 15.2+

**Linux (Ubuntu/Debian):**
```bash
# Using test repository or compile from source
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-15 g++-15
```

**macOS:**
```bash
# GCC is not the preferred compiler on macOS, use Clang instead
brew install gcc@15
```

**Windows:**
- Use [MinGW-w64](https://www.mingw-w64.org/) or [MSYS2](https://www.msys2.org/)

### MSVC 19.42+

**Windows:**
- Install [Visual Studio 2022 17.12+](https://visualstudio.microsoft.com/)
- Or install [Visual Studio Build Tools 2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)

Select workloads:
- "Desktop development with C++"
- Ensure the latest MSVC toolset is selected

## 🔄 Version Checking

The project automatically checks compiler versions during configuration:

```bash
cmake -B build -G Ninja
```

If the compiler version doesn't meet requirements, an error will be displayed:

```
CMake Error: Clang 19.1+ required, but found 18.0.0
```

## 🐳 Docker Environment

If your local compiler version doesn't meet requirements, you can use pre-configured Docker environments:

```bash
# Build using Docker (includes correct compiler versions)
bash scripts/docker-build.sh -p linux -t Release
```

Docker images include:
- Clang 19.1+ (Linux containers)
- GCC 15.2+ (Linux containers)
- All necessary build tools

## ⚠️ Compatibility Notes

### Unsupported Older Versions

The following versions are **no longer supported** due to lack of complete C++ module implementation:

❌ Clang 18.x and earlier
❌ GCC 14.x and earlier
❌ MSVC 19.41 and earlier

### Standard Library Requirements

- **Clang**: Use libc++ or libstdc++ (libc++ 17+ recommended)
- **GCC**: Use libstdc++ 15+
- **MSVC**: Use built-in standard library (automatically matched)

## 📊 Performance Recommendations

### Module Compilation

C++ module compilation may be slower than traditional headers, but provides:
- Faster incremental compilation
- Better encapsulation
- Improved compiler diagnostics

### Optimization Recommendations

1. **Use precompiled module interfaces**
   ```bash
   cmake -B build -DAPE_TEMPLATE_PRECOMPILE_MODULES=ON
   ```

2. **Enable parallel compilation**
   ```bash
   cmake --build build --parallel $(nproc)
   ```

3. **Use ccache for acceleration**
   ```bash
   cmake -B build -DAPE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD=ON
   ```

## 🔧 Troubleshooting

### Issue: Cannot find specified compiler version

**Solution:**
```bash
# Explicitly specify compiler path
cmake -B build \
  -DCMAKE_C_COMPILER=/usr/bin/clang-19 \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++-19
```

### Issue: Module support not enabled

**Solution:**
```bash
# Ensure module support is enabled
cmake -B build -DAPE_TEMPLATE_USE_MODULES=ON
```

### Issue: Cannot find standard library modules

**Solution:**

For Clang:
```bash
# Ensure correct standard library is used
cmake -B build -DCMAKE_CXX_FLAGS="-stdlib=libc++"
```

For GCC:
```bash
# Ensure correct standard library path
export LD_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/15:$LD_LIBRARY_PATH
```

## 📚 Related Resources

- [Clang Release Notes](https://releases.llvm.org/)
- [GCC Release Notes](https://gcc.gnu.org/releases.html)
- [MSVC Release Notes](https://docs.microsoft.com/en-us/cpp/overview/what-s-new-for-visual-cpp-in-visual-studio)
- [C++23 Compiler Support](https://en.cppreference.com/w/cpp/compiler_support/23)
- [C++ Modules Documentation](https://en.cppreference.com/w/cpp/language/modules)

## 🔄 Update History

| Date | Version Requirements | Notes |
|------|---------------------|-------|
| 2025-11-01 | Clang 19.1+, GCC 15.2+, MSVC 19.42+ | Initial version with full C++ module support |

---

**Note**: These version requirements will be updated as compilers evolve and C++ standards progress.

