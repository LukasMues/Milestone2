# Prerequisites Installation Script for Milestone 2 Project
# This script will install Docker Desktop, kubectl, and kind on Windows

param(
    [switch]$SkipDocker,
    [switch]$SkipKubectl,
    [switch]$SkipKind,
    [switch]$Force
)

Write-Host "🚀 Milestone 2 Project - Prerequisites Installation" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠️  Warning: This script is not running as administrator." -ForegroundColor Yellow
    Write-Host "   Some installations may require elevated privileges." -ForegroundColor Yellow
    Write-Host ""
}

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to install Chocolatey
function Install-Chocolatey {
    if (Test-Command choco) {
        Write-Host "✅ Chocolatey is already installed" -ForegroundColor Green
        return
    }
    
    Write-Host "📦 Installing Chocolatey..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "✅ Chocolatey installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to install Chocolatey: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "   Please install Chocolatey manually from https://chocolatey.org/install" -ForegroundColor Yellow
        return $false
    }
    return $true
}

# 1. Install Docker Desktop
if (-not $SkipDocker) {
    Write-Host ""
    Write-Host "🐳 Checking Docker Desktop..." -ForegroundColor Cyan
    
    if (Test-Command docker) {
        $dockerVersion = docker --version
        Write-Host "✅ Docker is already installed: $dockerVersion" -ForegroundColor Green
    }
    else {
        Write-Host "📥 Docker Desktop not found. Installing..." -ForegroundColor Yellow
        
        # Try to install via Chocolatey first
        if (Install-Chocolatey) {
            try {
                Write-Host "📦 Installing Docker Desktop via Chocolatey..." -ForegroundColor Yellow
                choco install docker-desktop -y
                Write-Host "✅ Docker Desktop installed via Chocolatey" -ForegroundColor Green
                Write-Host "🔄 Please restart your computer and start Docker Desktop manually" -ForegroundColor Yellow
            }
            catch {
                Write-Host "❌ Failed to install Docker Desktop via Chocolatey" -ForegroundColor Red
                Write-Host "📥 Please download and install Docker Desktop manually from:" -ForegroundColor Yellow
                Write-Host "   https://www.docker.com/products/docker-desktop/" -ForegroundColor Cyan
            }
        }
        else {
            Write-Host "📥 Please download and install Docker Desktop manually from:" -ForegroundColor Yellow
            Write-Host "   https://www.docker.com/products/docker-desktop/" -ForegroundColor Cyan
        }
    }
}

# 2. Install kubectl
if (-not $SkipKubectl) {
    Write-Host ""
    Write-Host "⚙️  Checking kubectl..." -ForegroundColor Cyan
    
    if (Test-Command kubectl) {
        $kubectlVersion = kubectl version --client --short
        Write-Host "✅ kubectl is already installed: $kubectlVersion" -ForegroundColor Green
    }
    else {
        Write-Host "📥 kubectl not found. Installing..." -ForegroundColor Yellow
        
        # Try to install via Chocolatey first
        if (Install-Chocolatey) {
            try {
                Write-Host "📦 Installing kubectl via Chocolatey..." -ForegroundColor Yellow
                choco install kubernetes-cli -y
                Write-Host "✅ kubectl installed via Chocolatey" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Failed to install kubectl via Chocolatey" -ForegroundColor Red
                Write-Host "📥 Please download kubectl manually from:" -ForegroundColor Yellow
                Write-Host "   https://kubernetes.io/docs/tasks/tools/install-kubectl/" -ForegroundColor Cyan
            }
        }
        else {
            Write-Host "📥 Please download kubectl manually from:" -ForegroundColor Yellow
            Write-Host "   https://kubernetes.io/docs/tasks/tools/install-kubectl/" -ForegroundColor Cyan
        }
    }
}

# 3. Install kind
if (-not $SkipKind) {
    Write-Host ""
    Write-Host "🎯 Checking kind..." -ForegroundColor Cyan
    
    # Check if kind is in PATH
    if (Test-Command kind) {
        $kindVersion = kind version
        Write-Host "✅ kind is already installed: $kindVersion" -ForegroundColor Green
    }
    # Check if kind is in tools directory
    elseif (Test-Path "$env:USERPROFILE\tools\kind.exe") {
        $kindVersion = & "$env:USERPROFILE\tools\kind.exe" version
        Write-Host "✅ kind is already installed: $kindVersion" -ForegroundColor Green
    }
    else {
        Write-Host "📥 kind not found. Installing..." -ForegroundColor Yellow
        
        try {
            # Create tools directory
            $toolsDir = "$env:USERPROFILE\tools"
            if (!(Test-Path $toolsDir)) {
                New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
                Write-Host "📁 Created tools directory: $toolsDir" -ForegroundColor Green
            }
            
            # Download kind
            Write-Host "📥 Downloading kind..." -ForegroundColor Yellow
            $kindUrl = "https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64"
            $kindPath = "$toolsDir\kind.exe"
            Invoke-WebRequest -Uri $kindUrl -OutFile $kindPath
            
            Write-Host "✅ kind downloaded successfully" -ForegroundColor Green
            
            # Add to PATH
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            if ($currentPath -notlike "*$toolsDir*") {
                [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$toolsDir", "User")
                Write-Host "✅ Added $toolsDir to PATH" -ForegroundColor Green
                Write-Host "🔄 Please restart your terminal to use kind from PATH" -ForegroundColor Yellow
            }
            
            # Test the installation
            $kindVersion = & $kindPath version
            Write-Host "✅ kind installed successfully: $kindVersion" -ForegroundColor Green
            
        }
        catch {
            Write-Host "❌ Failed to install kind: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "📥 Please download kind manually from:" -ForegroundColor Yellow
            Write-Host "   https://kind.sigs.k8s.io/docs/user/quick-start/" -ForegroundColor Cyan
        }
    }
}

# 4. Verify installations
Write-Host ""
Write-Host "🔍 Verifying installations..." -ForegroundColor Cyan

$allGood = $true

# Check Docker
if (-not $SkipDocker) {
    if (Test-Command docker) {
        Write-Host "✅ Docker: $(docker --version)" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Docker: Not found" -ForegroundColor Red
        $allGood = $false
    }
}

# Check kubectl
if (-not $SkipKubectl) {
    if (Test-Command kubectl) {
        Write-Host "✅ kubectl: $(kubectl version --client --short)" -ForegroundColor Green
    }
    else {
        Write-Host "❌ kubectl: Not found" -ForegroundColor Red
        $allGood = $false
    }
}

# Check kind
if (-not $SkipKind) {
    if (Test-Command kind) {
        Write-Host "✅ kind: $(kind version)" -ForegroundColor Green
    }
    elseif (Test-Path "$env:USERPROFILE\tools\kind.exe") {
        Write-Host "✅ kind: $(& "$env:USERPROFILE\tools\kind.exe" version)" -ForegroundColor Green
    }
    else {
        Write-Host "❌ kind: Not found" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""
if ($allGood) {
    Write-Host "🎉 All prerequisites are installed and ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Cyan
    Write-Host "   1. Start Docker Desktop" -ForegroundColor White
    Write-Host "   2. Restart your terminal (to update PATH)" -ForegroundColor White
    Write-Host "   3. Run: powershell -ExecutionPolicy Bypass -File run.ps1 all" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 For detailed instructions, see GETTING_STARTED.md" -ForegroundColor Cyan
}
else {
    Write-Host "⚠️  Some installations failed. Please check the errors above." -ForegroundColor Yellow
    Write-Host "📚 See GETTING_STARTED.md for manual installation instructions." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 