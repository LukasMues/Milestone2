# Print Kubernetes cluster configuration (PowerShell version)

Write-Host "=== Kubernetes Cluster Configuration ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Cluster Info:" -ForegroundColor Yellow
kubectl cluster-info
Write-Host ""

Write-Host "Nodes:" -ForegroundColor Yellow
kubectl get nodes -o wide
Write-Host ""

Write-Host "Context:" -ForegroundColor Yellow
kubectl config current-context
Write-Host ""

Write-Host "Namespaces:" -ForegroundColor Yellow
kubectl get namespaces
Write-Host ""

Write-Host "Storage Classes:" -ForegroundColor Yellow
kubectl get storageclass
Write-Host ""

Write-Host "=== End Configuration ===" -ForegroundColor Cyan 