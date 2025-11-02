# 项目重命名检查清单

本文档列出从 `ape2` 到 `ape-template` 的重命名进度和剩余工作。

## ✅ 已完成的更改

### 1. CMake配置 ✅
- [x] `CMakeLists.txt` - 项目名称、所有变量前缀
- [x] `cmake/ape-templateConfig.cmake.in` - 重命名和内容更新
- [x] `src/CMakeLists.txt` - 库名称和命名空间
- [x] `src/core/CMakeLists.txt` - 库名称和路径
- [x] `src/utils/CMakeLists.txt` - 库名称和路径
- [x] `cmake/modules/CompilerWarnings.cmake` - 警告库名称

### 2. 目录和文件 ✅
- [x] `include/ape2/` → `include/ape_template/`
- [x] `cmake/ape2Config.cmake.in` → `cmake/ape-templateConfig.cmake.in`

### 3. 源代码和头文件 ✅
- [x] `include/ape_template/core/version.hpp` - 命名空间
- [x] `include/ape_template/utils/string_utils.hpp` - 命名空间
- [x] `src/core/version.cpp` - 命名空间和包含路径
- [x] `src/utils/string_utils.cpp` - 命名空间和包含路径

### 4. 测试文件 ✅
- [x] `tests/CMakeLists.txt` - 所有变量和库名称
- [x] `tests/unit/test_version.cpp` - 命名空间和包含路径
- [x] `tests/unit/test_string_utils.cpp` - 命名空间和包含路径
- [x] `tests/regression/regression_suite.cpp` - 命名空间和包含路径
- [x] `tests/regression/CMakeLists.txt` - 库名称
- [x] `tests/fuzz/fuzz_string_utils.cpp` - 命名空间和包含路径
- [x] `tests/fuzz/CMakeLists.txt` - 库名称
- [x] `tests/benchmark/bench_string_utils.cpp` - 命名空间和包含路径
- [x] `tests/benchmark/CMakeLists.txt` - 库名称

### 5. 文档 ✅
- [x] `README.md` - 完全重写，强调模板特性

## 🔄 需要更新的文件

以下文件包含 `ape2` 或 `APE2` 引用，需要批量更新：

### Docker配置
- [ ] `docker/linux/Dockerfile` - 注释和标签
- [ ] `docker/android/Dockerfile` - 注释和标签
- [ ] `docker/webassembly/Dockerfile` - 注释和标签

### 构建脚本
- [ ] `scripts/docker-build.sh` - 镜像名称 `ape2-*` → `ape-template-*`
- [ ] `scripts/docker-build.ps1` - 镜像名称
- [ ] `scripts/docker-shell.sh` - 镜像名称和容器名称

### GitHub Actions
- [ ] `.github/workflows/ci.yml` - 所有 `APE2_*` 变量 → `APE_TEMPLATE_*`
- [ ] `.github/workflows/docker.yml` - 镜像名称和构建产物名称
- [ ] `.github/workflows/documentation.yml` - 变量名称
- [ ] `.github/workflows/release.yml` - 产物名称

### 包管理
- [ ] `conanfile.txt` - 注释
- [ ] `conanfile.py` - 项目名称、类名、包信息、库名称
- [ ] `vcpkg.json` - 项目名称和描述

### 文档配置
- [ ] `docs/Doxyfile.in` - 项目信息
- [ ] `docs/CMakeLists.txt` - 注释

### 其他文档
- [ ] `BUILD_INSTRUCTIONS.md` - 项目名称引用
- [ ] `CONTRIBUTING.md` - 项目名称和URL
- [ ] `PROJECT_STRUCTURE.md` - 项目名称和路径
- [ ] `COMPILER_VERSIONS.md` - 项目名称
- [ ] `INITIALIZATION_SUMMARY.md` - 项目名称

### 配置文件
- [ ] `.vscode/settings.json` - cSpell词汇列表
- [ ] `.vscode/c_cpp_properties.json` - 包含路径

### 其他
- [ ] `.clang-tidy` - HeaderFilterRegex路径
- [ ] `LICENSE` - 更新版权持有人（如需要）

## 🔍 快速批量替换指南

使用以下命令进行批量替换（Linux/macOS）：

```bash
# 替换 ape2:: 为 ape_template::
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" -o -name "*.txt" -o -name "*.py" -o -name "*.json" \) \
  -exec sed -i '' 's/ape2::/ape_template::/g' {} +

# 替换 ape2_ 为 ape_template_
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/ape2_/ape_template_/g' {} +

# 替换 ape2- 为 ape-template-
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/ape2-/ape-template-/g' {} +

# 替换 APE2_ 为 APE_TEMPLATE_
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/APE2_/APE_TEMPLATE_/g' {} +

# 替换 /ape2 为 /ape_template（路径）
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) \
  -exec sed -i '' 's/\/ape2/\/ape_template/g' {} +
```

Windows PowerShell：

```powershell
# 替换文本中的 ape2
Get-ChildItem -Recurse -Include *.md,*.yml,*.yaml,*.sh,*.ps1,*.txt,*.py,*.json |
  ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace 'ape2::','ape_template::' -replace 'ape2_','ape_template_' -replace 'ape2-','ape-template-' -replace 'APE2_','APE_TEMPLATE_' -replace '/ape2','ape_template' |
    Set-Content $_.FullName -NoNewline
  }
```

## ⚠️ 特别注意

1. **URL更新**：所有GitHub URL需要从 `xbigo/ape2` 更新为 `xbigo/ape-template`

2. **镜像名称**：Docker镜像名称需要从 `ape2-linux` 等更新为 `ape-template-linux`

3. **构建产物**：CI/CD中的构建产物名称需要更新

4. **变量前缀**：所有CMake变量从 `APE2_*` 更新为 `APE_TEMPLATE_*`

5. **库名称**：所有库从 `ape2_*` 更新为 `ape_template_*`

6. **命名空间**：所有C++命名空间从 `ape2::` 更新为 `ape_template::`

## ✅ 验证清单

完成所有更改后，执行以下检查：

```bash
# 1. 搜索残留的 ape2 引用（应该没有结果或只有历史文档）
grep -r "ape2" --exclude-dir=.git --exclude-dir=build* .

# 2. 搜索残留的 APE2 引用
grep -r "APE2" --exclude-dir=.git --exclude-dir=build* .

# 3. 验证CMake配置
cmake -B build -G Ninja
# 应该显示 "ape-template 0.1.0"

# 4. 验证编译
cmake --build build --parallel

# 5. 验证测试
cd build && ctest --output-on-failure

# 6. 检查Docker镜像名称
docker images | grep ape-template
```

## 📝 建议的工作流程

1. **完成代码更改** ✅
   - 已完成核心代码和CMake配置

2. **批量更新配置文件** ⏳
   - 使用上述批量替换命令
   - 手动检查重要文件

3. **更新文档** ⏳
   - 逐个更新文档文件
   - 确保描述准确反映"模板"性质

4. **测试验证** ⏳
   - 本地构建测试
   - Docker构建测试
   - CI/CD测试

5. **提交更改** ⏳
   ```bash
   git add .
   git commit -m "Rename project from ape2 to ape-template"
   ```

## 🎯 最终目标

确保项目：
- ✅ 所有代码和配置文件已更新
- ✅ 能够成功编译
- ✅ 所有测试通过
- ✅ Docker构建正常
- ✅ CI/CD工作流正常
- ✅ 文档准确反映项目作为模板的定位

---

**当前状态**: 核心代码和CMake配置已完成，配置文件和文档待更新
**最后更新**: 2025-11-01

