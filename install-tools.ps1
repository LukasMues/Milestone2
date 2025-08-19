# Install required tools for Milestone 2

Write-Host "Installing required tools..." -ForegroundColor Green

# Create tools directory
$toolsDir = "$env:USERPROFILE\tools"
if (!(Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir
}

# Download and install kind
Write-Host "Installing kind..." -ForegroundColor Yellow
$kindUrl = "https://kind.sigs.k8s.io/dl/v0.20.0/kind-windows-amd64"
$kindPath = "$toolsDir\kind.exe"
Invoke-WebRequest -Uri $kindUrl -OutFile $kindPath

# Download and install make (using chocolatey if available, otherwise manual)
Write-Host "Installing make..." -ForegroundColor Yellow
try {
    # Try to use chocolatey if available
    choco install make -y
} catch {
    Write-Host "Chocolatey not available, downloading make manually..." -ForegroundColor Yellow
    # For now, we'll create a simple make replacement
    $makeScript = @"
# Simple make replacement for Windows
param([string]`$target)

function Build-Images {
    Write-Host "Building Docker images..." -ForegroundColor Green
    docker build -t frontend-lm:latest frontend/
    docker build -t api-lm:latest api/
    docker build -t postgres-lm:latest db/
}

function Load-Images {
    Write-Host "Loading images to cluster..." -ForegroundColor Green
    kind load docker-image frontend-lm:latest
    kind load docker-image api-lm:latest
    kind load docker-image postgres-lm:latest
}

function Deploy-Application {
    Write-Host "Deploying to Kubernetes..." -ForegroundColor Green
    kubectl apply -f k8s/namespace.yaml
    kubectl apply -f k8s/postgres/
    kubectl apply -f k8s/api/
    kubectl apply -f k8s/frontend/
}

function Show-Status {
    Write-Host "=== Namespace ===" -ForegroundColor Cyan
    kubectl get namespace lm-webstack
    Write-Host "`n=== Pods ===" -ForegroundColor Cyan
    kubectl get pods -n lm-webstack
    Write-Host "`n=== Services ===" -ForegroundColor Cyan
    kubectl get services -n lm-webstack
}

function Start-Cluster {
    Write-Host "Starting Kubernetes cluster..." -ForegroundColor Green
    powershell -ExecutionPolicy Bypass -File .\scripts\kind-up.ps1
}

function Stop-Cluster {
    Write-Host "Stopping Kubernetes cluster..." -ForegroundColor Yellow
    powershell -ExecutionPolicy Bypass -File .\scripts\kind-down.ps1
}

function Access-Frontend {
    Write-Host "Port forwarding to frontend service..." -ForegroundColor Green
    Write-Host "Access at: http://localhost:8080" -ForegroundColor Cyan
    kubectl port-forward -n lm-webstack svc/frontend-lm 8080:80
}

function Access-API {
    Write-Host "Port forwarding to API service..." -ForegroundColor Green
    Write-Host "Access at: http://localhost:8000" -ForegroundColor Cyan
    kubectl port-forward -n lm-webstack svc/api-lm 8000:8000
}

function Clean-Resources {
    Write-Host "Cleaning up Kubernetes resources..." -ForegroundColor Yellow
    kubectl delete namespace lm-webstack --ignore-not-found=true
}

function Deploy-All {
    Build-Images
    Load-Images
    Deploy-Application
    Show-Status
}

switch (`$target) {
    "cluster-up" { Start-Cluster }
    "cluster-down" { Stop-Cluster }
    "build" { Build-Images }
    "load-images" { Load-Images }
    "deploy" { Deploy-Application }
    "status" { Show-Status }
    "access-frontend" { Access-Frontend }
    "access-api" { Access-API }
    "clean" { Clean-Resources }
    "all" { Deploy-All }
    default { 
        Write-Host "Available targets:" -ForegroundColor Cyan
        Write-Host "  cluster-up     - Start Kubernetes cluster"
        Write-Host "  cluster-down   - Stop Kubernetes cluster"
        Write-Host "  build          - Build all Docker images"
        Write-Host "  load-images    - Load images to cluster"
        Write-Host "  deploy         - Deploy application to Kubernetes"
        Write-Host "  status         - Show deployment status"
        Write-Host "  access-frontend - Port forward to frontend service"
        Write-Host "  access-api     - Port forward to API service"
        Write-Host "  clean          - Remove all Kubernetes resources"
        Write-Host "  all            - Build, load, and deploy everything"
    }
}
"@
    $makeScript | Out-File -FilePath "$toolsDir\make.ps1" -Encoding UTF8
}

# Add tools to PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$toolsDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$toolsDir", "User")
    Write-Host "Added $toolsDir to PATH. Please restart your terminal." -ForegroundColor Yellow
}

Write-Host "Installation completed!" -ForegroundColor Green
Write-Host "Please restart your terminal and try running the project again." -ForegroundColor Yellow 