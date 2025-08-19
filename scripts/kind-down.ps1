# Stop kind cluster for Milestone 2 (PowerShell version)

Write-Host "Stopping kind cluster..." -ForegroundColor Yellow

# Delete cluster
kind delete cluster --name milestone2

Write-Host "Kind cluster 'milestone2' has been stopped." -ForegroundColor Green 