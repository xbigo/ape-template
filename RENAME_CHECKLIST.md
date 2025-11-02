# Project Rename Checklist

This document lists the progress and remaining work for renaming from `ape-template` to `ape-template`.

## ✅ Completed Changes

### 1. CMake Configuration ✅
- [x] `CMakeLists.txt` - Project name, all variable prefixes
- [x] `cmake/ape-templateConfig.cmake.in` - Renaming and content updates
- [x] `src/CMakeLists.txt` - Library names and namespaces
- [x] `src/core/CMakeLists.txt` - Library names and paths
- [x] `src/utils/CMakeLists.txt` - Library names and paths
- [x] `cmake/modules/CompilerWarnings.cmake` - Warning library name

### 2. Directories and Files ✅
- [x] `include/ape-template/` → `include/ape_template/`
- [x] `cmake/ape-templateConfig.cmake.in` → `cmake/ape-templateConfig.cmake.in`

### 3. Source Code and Headers ✅
- [x] `include/ape_template/core/version.hpp` - Namespace
- [x] `include/ape_template/utils/string_utils.hpp` - Namespace
- [x] `src/core/version.cpp` - Namespace and include paths
- [x] `src/utils/string_utils.cpp` - Namespace and include paths

### 4. Test Files ✅
- [x] `tests/CMakeLists.txt` - All variables and library names
- [x] `tests/unit/test_version.cpp` - Namespace and include paths
- [x] `tests/unit/test_string_utils.cpp` - Namespace and include paths
- [x] `tests/regression/regression_suite.cpp` - Namespace and include paths
- [x] `tests/regression/CMakeLists.txt` - Library names
- [x] `tests/fuzz/fuzz_string_utils.cpp` - Namespace and include paths
- [x] `tests/fuzz/CMakeLists.txt` - Library names
- [x] `tests/benchmark/bench_string_utils.cpp` - Namespace and include paths
- [x] `tests/benchmark/CMakeLists.txt` - Library names

### 5. Documentation ✅
- [x] `README.md` - Complete rewrite, emphasizing template nature

## 🔄 Files Needing Updates

The following files contain `ape-template` or `APE2` references and need bulk updates:

### Docker Configuration
- [ ] `docker/linux/Dockerfile` - Comments and labels
- [ ] `docker/android/Dockerfile` - Comments and labels
- [ ] `docker/webassembly/Dockerfile` - Comments and labels

### Build Scripts
- [ ] `scripts/docker-build.sh` - Image names `ape-template-*` → `ape-template-*`
- [ ] `scripts/docker-build.ps1` - Image names
- [ ] `scripts/docker-shell.sh` - Image names and container names

### GitHub Actions
- [ ] `.github/workflows/ci.yml` - All `APE2_*` variables → `APE_TEMPLATE_*`
- [ ] `.github/workflows/docker.yml` - Image names and artifact names
- [ ] `.github/workflows/documentation.yml` - Variable names
- [ ] `.github/workflows/release.yml` - Artifact names

### Package Management
- [ ] `conanfile.txt` - Comments
- [ ] `conanfile.py` - Project name, class name, package info, library names
- [ ] `vcpkg.json` - Project name and description

### Documentation Configuration
- [ ] `docs/Doxyfile.in` - Project information
- [ ] `docs/CMakeLists.txt` - Comments

### Other Documentation
- [ ] `BUILD_INSTRUCTIONS.md` - Project name references
- [ ] `CONTRIBUTING.md` - Project name and URL
- [ ] `PROJECT_STRUCTURE.md` - Project name and paths
- [ ] `COMPILER_VERSIONS.md` - Project name
- [ ] `INITIALIZATION_SUMMARY.md` - Project name

### Configuration Files
- [ ] `.vscode/settings.json` - cSpell vocabulary list
- [ ] `.vscode/c_cpp_properties.json` - Include paths

### Other
- [ ] `.clang-tidy` - HeaderFilterRegex path
- [ ] `LICENSE` - Update copyright holder (if needed)

## 🔍 Quick Bulk Replace Guide

Use the following commands for bulk replacement (Linux/macOS):

```bash
# Replace ape-template:: with ape_template::
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" -o -name "*.txt" -o -name "*.py" -o -name "*.json" \) \
  -exec sed -i '' 's/ape-template::/ape_template::/g' {} +

# Replace ape-template_ with ape_template_
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/ape-template_/ape_template_/g' {} +

# Replace ape-template- with ape-template-
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/ape-template-/ape-template-/g' {} +

# Replace APE2_ with APE_TEMPLATE_
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sh" -o -name "*.ps1" \) \
  -exec sed -i '' 's/APE2_/APE_TEMPLATE_/g' {} +

# Replace /ape-template with /ape_template (paths)
find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) \
  -exec sed -i '' 's/\/ape-template/\/ape_template/g' {} +
```

Windows PowerShell:

```powershell
# Replace ape-template in text
Get-ChildItem -Recurse -Include *.md,*.yml,*.yaml,*.sh,*.ps1,*.txt,*.py,*.json |
  ForEach-Object {
    (Get-Content $_.FullName) -replace 'ape-template::','ape_template::' -replace 'ape-template_','ape_template_' -replace 'ape-template-','ape-template-' -replace 'APE2_','APE_TEMPLATE_' -replace '/ape-template','ape_template' |
    Set-Content $_.FullName
  }
```

## ⚠️ Special Notes

1. **URL Updates**: All GitHub URLs need to be updated from `xbigo/ape-template` to `xbigo/ape-template`

2. **Image Names**: Docker image names need to be updated from `ape-template-linux` etc. to `ape-template-linux`

3. **Build Artifacts**: Build artifact names in CI/CD need to be updated

4. **Variable Prefixes**: All CMake variables from `APE2_*` to `APE_TEMPLATE_*`

5. **Library Names**: All libraries from `ape-template_*` to `ape_template_*`

6. **Namespaces**: All C++ namespaces from `ape-template::` to `ape_template::`

## ✅ Verification Checklist

After completing all changes, perform the following checks:

```bash
# 1. Search for remaining ape-template references (should have no results or only in historical documentation)
grep -r "ape-template" --exclude-dir=.git --exclude-dir=build* .

# 2. Search for remaining APE2 references
grep -r "APE2" --exclude-dir=.git --exclude-dir=build* .

# 3. Verify CMake configuration
cmake -B build -G Ninja
# Should display "ape-template 0.1.0"

# 4. Verify compilation
cmake --build build --parallel

# 5. Verify tests
cd build && ctest --output-on-failure

# 6. Check Docker image names
docker images | grep ape-template
```

## 📝 Suggested Workflow

1. **Complete Code Changes** ✅
   - Core code and CMake configuration completed

2. **Bulk Update Configuration Files** ⏳
   - Use the bulk replacement commands above
   - Manually check important files

3. **Update Documentation** ⏳
   - Update documentation files one by one
   - Ensure descriptions accurately reflect "template" nature

4. **Test and Verify** ⏳
   - Local build tests
   - Docker build tests
   - CI/CD tests

5. **Commit Changes** ⏳
   ```bash
   git add .
   git commit -m "Rename project from ape-template to ape-template"
   ```

## 🎯 Final Goal

Ensure the project:
- ✅ All code and configuration files updated
- ✅ Successfully compiles
- ✅ All tests pass
- ✅ Docker builds work
- ✅ CI/CD workflows work
- ✅ Documentation accurately reflects the project's positioning as a template

---

**Current Status**: Core code and CMake configuration completed, configuration files and documentation pending
**Last Updated**: 2025-11-01

