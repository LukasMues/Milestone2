# Monitoring Test Script
param([int]$requests = 50)

Write-Host "Testing monitoring setup with $requests requests..." -ForegroundColor Green
Write-Host "This will generate metrics for Prometheus to collect" -ForegroundColor Yellow

$results = @()
$uniqueContainers = @{}

try {
    for ($i = 1; $i -le $requests; $i++) {
        try {
            # Test API endpoints to generate metrics
            $response = Invoke-RestMethod -Uri "http://localhost:8000/user" -Method Get
            $response = Invoke-RestMethod -Uri "http://localhost:8000/container-id" -Method Get
            $containerId = $response.container_id
            
            $results += $containerId
            if ($uniqueContainers.ContainsKey($containerId)) {
                $uniqueContainers[$containerId]++
            } else {
                $uniqueContainers[$containerId] = 1
            }
            
            # Update user occasionally to test POST metrics
            if ($i % 10 -eq 0) {
                $updateData = @{ name = "User_$i" } | ConvertTo-Json
                $response = Invoke-RestMethod -Uri "http://localhost:8000/user" -Method POST -Body $updateData -ContentType "application/json"
                Write-Host "Updated user to: $($response.name)" -ForegroundColor Cyan
            }
            
            Write-Host "Request $i`: $containerId" -ForegroundColor Gray
            
            # Small delay between requests
            Start-Sleep -Milliseconds 100
        } catch (error) {
            Write-Host "Error in request $i`: $error" -ForegroundColor Red
        }
    }
    
    # Show summary
    Write-Host "`n=== Test Summary ===" -ForegroundColor Green
    Write-Host "Total requests: $($results.Count)" -ForegroundColor Cyan
    Write-Host "Unique containers: $($uniqueContainers.Count)" -ForegroundColor Cyan
    Write-Host "Load distribution:" -ForegroundColor Cyan
    foreach ($container in $uniqueContainers.Keys) {
        $percentage = [math]::Round(($uniqueContainers[$container] / $results.Count) * 100, 1)
        Write-Host "  $container`: $($uniqueContainers[$container]) requests ($percentage%)" -ForegroundColor White
    }
    
    Write-Host "`n=== Next Steps ===" -ForegroundColor Green
    Write-Host "1. Access Prometheus: http://localhost:9090" -ForegroundColor Cyan
    Write-Host "2. Check Targets page to see scraped endpoints" -ForegroundColor Cyan
    Write-Host "3. Query metrics like: http_requests_total" -ForegroundColor Cyan
    Write-Host "4. View graphs and dashboards" -ForegroundColor Cyan
    
} catch {
    Write-Host "Error running test: $_" -ForegroundColor Red
}
