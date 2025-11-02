# Docker build helper script for ape-template project (PowerShell)

param(
    [string]$Platform = "linux",
    [string]$BuildType = "Release",
    [string]$Compiler = "gcc",
    [string]$Sanitizer = "",
    [switch]$RunTests = $false,
    [switch]$Help = $false
)

function Show-Usage {
    Write-Host "Usage: docker-build.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Platform <PLATFORM>      Platform to build (linux|android|webassembly) [default: linux]"
    Write-Host "  -BuildType <BUILD_TYPE>   Build type (Debug|Release|FastDebug|SlowRelease) [default: Release]"
    Write-Host "  -Compiler <COMPILER>      Compiler to use (gcc|clang) [default: gcc]"
    Write-Host "  -Sanitizer <TYPE>         Enable sanitizer (address|memory|thread|undefined|leak)"
    Write-Host "  -RunTests                 Run tests after building"
    Write-Host "  -Help                     Show this help message"
    exit 0
}

if ($Help) {
    Show-Usage
}

# Validate platform
if ($Platform -notin @("linux", "android", "webassembly")) {
    Write-Host "Error: Invalid platform '$Platform'" -ForegroundColor Red
    Show-Usage
}

$DockerfileDir = "docker\$Platform"
$ImageName = "ape-template-${Platform}:latest"
$ContainerName = "ape-template-${Platform}-build"
$BuildDir = "build-$Platform-$($BuildType.ToLower())"

Write-Host "Building ape-template for platform: $Platform" -ForegroundColor Green
Write-Host "Build type: $BuildType" -ForegroundColor Green
Write-Host "Compiler: $Compiler" -ForegroundColor Green

# Build Docker image
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t $ImageName $DockerfileDir

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker image build failed!" -ForegroundColor Red
    exit 1
}

# Prepare build directory
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null

# Get absolute paths (Docker needs absolute paths on Windows)
$WorkspaceDir = (Get-Location).Path
$BuildDirAbs = Join-Path $WorkspaceDir $BuildDir

# Convert Windows paths to Unix-style for Docker
$WorkspaceDirUnix = $WorkspaceDir -replace '\\', '/' -replace ':', ''
$WorkspaceDirUnix = "/$WorkspaceDirUnix"
$BuildDirUnix = $BuildDirAbs -replace '\\', '/' -replace ':', ''
$BuildDirUnix = "/$BuildDirUnix"

# Prepare CMake arguments
$CMakeArgs = "-DCMAKE_BUILD_TYPE=$BuildType"

if ($Compiler -eq "clang") {
    $CMakeArgs += " -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
}
else {
    $CMakeArgs += " -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
}

if ($Sanitizer -ne "") {
    $CMakeArgs += " -DAPE2_ENABLE_SANITIZERS=ON -DAPE2_SANITIZER_TYPE=$Sanitizer"
}

# Check if secrets directory has any files to mount
$SecretsMount = ""
$SecretsDir = Join-Path $WorkspaceDir "docker\secrets"
if ((Test-Path $SecretsDir) -and ((Get-ChildItem $SecretsDir).Count -gt 0)) {
    $SecretsDirUnix = $SecretsDir -replace '\\', '/' -replace ':', ''
    $SecretsDirUnix = "/$SecretsDirUnix"
    $SecretsMount = "-v ${SecretsDirUnix}:/secrets:ro"
}

# Determine number of processors
$NumProcs = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

# Run Docker container for building
Write-Host "Running build in Docker container..." -ForegroundColor Yellow

$DockerCmd = "docker run --rm " +
"--name $ContainerName " +
"-v ${WorkspaceDirUnix}:/workspace " +
"-v ${BuildDirUnix}:/build " +
"$SecretsMount " +
"-w /workspace " +
"-e CMAKE_BUILD_PARALLEL_LEVEL=$NumProcs " +
"$ImageName " +
"bash -c `"cmake -B /build -S /workspace -G Ninja $CMakeArgs && cmake --build /build --parallel`""

Invoke-Expression $DockerCmd

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build completed successfully!" -ForegroundColor Green

    # Run tests if requested
    if ($RunTests) {
        Write-Host "Running tests..." -ForegroundColor Yellow
        $TestCmd = "docker run --rm " +
        "-v ${WorkspaceDirUnix}:/workspace " +
        "-v ${BuildDirUnix}:/build " +
        "-w /build " +
        "$ImageName " +
        "bash -c `"ctest --output-on-failure`""

        Invoke-Expression $TestCmd

        if ($LASTEXITCODE -eq 0) {
            Write-Host "All tests passed!" -ForegroundColor Green
        }
        else {
            Write-Host "Some tests failed!" -ForegroundColor Red
            exit 1
        }
    }
}
else {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

