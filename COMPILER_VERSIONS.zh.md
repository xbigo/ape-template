# Compiler Version Requirements

本文档详细说明了ape-template项目对编译器版本的要求。

## 📋 最低版本要求

为了充分利用C++23的新特性，特别是完整的C++模块支持，本项目要求以下编译器版本：

| 编译器 | 最低版本 | 对应IDE/发行版 | 说明 |
|--------|---------|---------------|------|
| **Clang** | 19.1 | LLVM 19.1+ | 完整的C++23和模块支持 |
| **GCC** | 15.2 | GCC 15.2+ | 完整的C++23和模块支持 |
| **MSVC** | 19.42 | Visual Studio 2022 17.12+ | 完整的C++23和模块支持 |

## 🎯 为什么选择这些版本？

### Clang 19.1+
- ✅ 完整的C++23标准支持
- ✅ 稳定的C++模块实现
- ✅ 改进的标准库模块支持
- ✅ 更好的诊断信息和错误提示
- ✅ 优化的模块编译性能

### GCC 15.2+
- ✅ 完整的C++23标准支持
- ✅ 生产级的C++模块实现
- ✅ 标准库模块完全支持
- ✅ 改进的模块编译速度
- ✅ 更好的ABI稳定性

### MSVC 19.42+ (Visual Studio 2022 17.12+)
- ✅ 完整的C++23标准支持
- ✅ 稳定的C++模块实现
- ✅ 标准库模块完全支持
- ✅ 与Visual Studio IDE深度集成
- ✅ 优秀的调试体验

## 🔍 特性对比

### C++23 特性支持

| 特性 | Clang 19.1 | GCC 15.2 | MSVC 19.42 |
|------|-----------|---------|-----------|
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

## 📦 获取编译器

### Clang 19.1+

**Linux (Ubuntu/Debian):**
```bash
# 添加LLVM仓库
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main"

# 安装
sudo apt-get update
sudo apt-get install clang-19 clang++-19
```

**macOS:**
```bash
# 使用Homebrew
brew install llvm@19
```

**Windows:**
- 下载并安装 [LLVM 19.1+](https://releases.llvm.org/)

### GCC 15.2+

**Linux (Ubuntu/Debian):**
```bash
# 使用测试仓库或从源码编译
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-15 g++-15
```

**macOS:**
```bash
# GCC不是macOS的首选，建议使用Clang
brew install gcc@15
```

**Windows:**
- 使用 [MinGW-w64](https://www.mingw-w64.org/) 或 [MSYS2](https://www.msys2.org/)

### MSVC 19.42+

**Windows:**
- 安装 [Visual Studio 2022 17.12+](https://visualstudio.microsoft.com/)
- 或者安装 [Visual Studio Build Tools 2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)

选择工作负载：
- "使用C++的桌面开发"
- 确保选择最新的MSVC工具集

## 🔄 版本检查

项目会在配置时自动检查编译器版本：

```bash
cmake -B build -G Ninja
```

如果编译器版本不满足要求，会显示类似错误：

```
CMake Error: Clang 19.1+ required, but found 18.0.0
```

## 🐳 Docker环境

如果本地编译器版本不满足要求，可以使用预配置的Docker环境：

```bash
# 使用Docker构建（包含正确版本的编译器）
bash scripts/docker-build.sh -p linux -t Release
```

Docker镜像包含：
- Clang 19.1+ (Linux容器)
- GCC 15.2+ (Linux容器)
- 所有必要的构建工具

## ⚠️ 兼容性说明

### 不支持的旧版本

以下版本**不再支持**，因为缺少完整的C++模块实现：

❌ Clang 18.x 及更早版本
❌ GCC 14.x 及更早版本
❌ MSVC 19.41 及更早版本

### 标准库要求

- **Clang**: 使用 libc++ 或 libstdc++（推荐 libc++ 17+）
- **GCC**: 使用 libstdc++ 15+
- **MSVC**: 使用内置的标准库（自动匹配）

## 📊 性能建议

### 模块编译

C++模块的编译可能比传统头文件慢，但会带来：
- 更快的增量编译
- 更好的封装性
- 改进的编译器诊断

### 优化建议

1. **使用预编译模块接口**
   ```bash
   cmake -B build -DAPE_TEMPLATE_PRECOMPILE_MODULES=ON
   ```

2. **启用并行编译**
   ```bash
   cmake --build build --parallel $(nproc)
   ```

3. **使用ccache加速**
   ```bash
   cmake -B build -DAPE_TEMPLATE_ENABLE_DISTRIBUTED_BUILD=ON
   ```

## 🔧 故障排除

### 问题：找不到指定版本的编译器

**解决方案：**
```bash
# 明确指定编译器路径
cmake -B build \
  -DCMAKE_C_COMPILER=/usr/bin/clang-19 \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++-19
```

### 问题：模块支持未启用

**解决方案：**
```bash
# 确保启用了模块支持
cmake -B build -DAPE_TEMPLATE_USE_MODULES=ON
```

### 问题：标准库模块找不到

**解决方案：**

对于Clang：
```bash
# 确保使用正确的标准库
cmake -B build -DCMAKE_CXX_FLAGS="-stdlib=libc++"
```

对于GCC：
```bash
# 确保使用正确的标准库路径
export LD_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/15:$LD_LIBRARY_PATH
```

## 📚 相关资源

- [Clang Release Notes](https://releases.llvm.org/)
- [GCC Release Notes](https://gcc.gnu.org/releases.html)
- [MSVC Release Notes](https://docs.microsoft.com/en-us/cpp/overview/what-s-new-for-visual-cpp-in-visual-studio)
- [C++23 Compiler Support](https://en.cppreference.com/w/cpp/compiler_support/23)
- [C++ Modules Documentation](https://en.cppreference.com/w/cpp/language/modules)

## 🔄 更新历史

| 日期 | 版本要求 | 说明 |
|------|---------|------|
| 2025-11-01 | Clang 19.1+, GCC 15.2+, MSVC 19.42+ | 初始版本，完整的C++模块支持 |

---

**注意**: 这些版本要求会随着编译器的发展和C++标准的演进而更新。

