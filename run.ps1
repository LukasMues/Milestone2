# Simple project runner for Milestone 2
param([string]$action = "help")

function Start-Cluster {
    Write-Host "Starting Kubernetes cluster..." -ForegroundColor Green
    & "$env:USERPROFILE\tools\kind.exe" create cluster --name milestone2
    Write-Host "Cluster created successfully!" -ForegroundColor Green
}

function Build-Images {
    Write-Host "Building Docker images..." -ForegroundColor Green
    docker build -t frontend-lm:latest frontend/
    docker build -t api-lm:latest api/
    docker build -t postgres-lm:latest db/
    Write-Host "Images built successfully!" -ForegroundColor Green
}

function Load-Images {
    Write-Host "Loading images to cluster..." -ForegroundColor Green
    & "$env:USERPROFILE\tools\kind.exe" load docker-image frontend-lm:latest --name milestone2
    & "$env:USERPROFILE\tools\kind.exe" load docker-image api-lm:latest --name milestone2
    & "$env:USERPROFILE\tools\kind.exe" load docker-image postgres-lm:latest --name milestone2
    Write-Host "Images loaded successfully!" -ForegroundColor Green
}

function Deploy-Application {
    Write-Host "Deploying to Kubernetes..." -ForegroundColor Green
    kubectl apply -f k8s/namespace.yaml
    kubectl apply -f k8s/postgres/
    kubectl apply -f k8s/api/
    kubectl apply -f k8s/frontend/
    Write-Host "Application deployed successfully!" -ForegroundColor Green
}

function Show-Status {
    Write-Host "=== Namespace ===" -ForegroundColor Cyan
    kubectl get namespace lm-webstack
    Write-Host "`n=== Pods ===" -ForegroundColor Cyan
    kubectl get pods -n lm-webstack
    Write-Host "`n=== Services ===" -ForegroundColor Cyan
    kubectl get services -n lm-webstack
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

function Stop-Cluster {
    Write-Host "Stopping Kubernetes cluster..." -ForegroundColor Yellow
    & "$env:USERPROFILE\tools\kind.exe" delete cluster --name milestone2
    Write-Host "Cluster stopped successfully!" -ForegroundColor Green
}

function Deploy-All {
    Write-Host "=== Starting complete deployment ===" -ForegroundColor Green
    Start-Cluster
    Build-Images
    Load-Images
    Deploy-Application
    Write-Host "`nWaiting for pods to be ready..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    Show-Status
    Write-Host "`n=== Deployment completed! ===" -ForegroundColor Green
    Write-Host "To access the frontend, run: .\run.ps1 access-frontend" -ForegroundColor Cyan
    Write-Host "To access the API, run: .\run.ps1 access-api" -ForegroundColor Cyan
}

function Show-Help {
    Write-Host "=== Milestone 2 Project Runner ===" -ForegroundColor Cyan
    Write-Host "Available actions:" -ForegroundColor Yellow
    Write-Host "  start-cluster    - Start Kubernetes cluster"
    Write-Host "  build           - Build all Docker images"
    Write-Host "  load-images     - Load images to cluster"
    Write-Host "  deploy          - Deploy application to Kubernetes"
    Write-Host "  status          - Show deployment status"
    Write-Host "  access-frontend - Port forward to frontend service"
    Write-Host "  access-api      - Port forward to API service"
    Write-Host "  clean           - Remove all Kubernetes resources"
    Write-Host "  stop-cluster    - Stop Kubernetes cluster"
    Write-Host "  all             - Complete deployment (start, build, load, deploy)"
    Write-Host "  help            - Show this help message"
    Write-Host ""
    Write-Host "Quick start: .\run.ps1 all" -ForegroundColor Green
}

switch ($action) {
    "start-cluster" { Start-Cluster }
    "build" { Build-Images }
    "load-images" { Load-Images }
    "deploy" { Deploy-Application }
    "status" { Show-Status }
    "access-frontend" { Access-Frontend }
    "access-api" { Access-API }
    "clean" { Clean-Resources }
    "stop-cluster" { Stop-Cluster }
    "all" { Deploy-All }
    default { Show-Help }
} 