# Start kind cluster for Milestone 2 (PowerShell version)

Write-Host "Starting kind cluster..." -ForegroundColor Green

# Create kind cluster configuration
$kindConfig = @"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000
    hostPort: 30000
    protocol: TCP
- role: worker
"@

$kindConfig | Out-File -FilePath "kind-config.yaml" -Encoding UTF8

# Create cluster
kind create cluster --name milestone2 --config kind-config.yaml

# Wait for cluster to be ready
Write-Host "Waiting for cluster to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready node --all --timeout=120s

# Show cluster info
Write-Host "Cluster is ready!" -ForegroundColor Green
kubectl cluster-info
kubectl get nodes

# Clean up config file
Remove-Item -Path "kind-config.yaml" -Force

Write-Host "Kind cluster 'milestone2' is running." -ForegroundColor Green
Write-Host "To stop the cluster, run: ./scripts/kind-down.ps1" -ForegroundColor Cyan 