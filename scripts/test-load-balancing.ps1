# Load Balancing Test Script
param([int]$requests = 20)

Write-Host "Testing load balancing with $requests requests..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the test" -ForegroundColor Yellow

$results = @()
$uniqueContainers = @{}

try {
    for ($i = 1; $i -le $requests; $i++) {
        try {
            $response = Invoke-RestMethod -Uri "http://localhost:8000/container-id" -Method Get
            $containerId = $response.container_id
            
            $results += $containerId
            if ($uniqueContainers.ContainsKey($containerId)) {
                $uniqueContainers[$containerId]++
            } else {
                $uniqueContainers[$containerId] = 1
            }
            
            Write-Host "Request $i`: $containerId" -ForegroundColor Cyan
            
            # Small delay between requests
            Start-Sleep -Milliseconds 200
        } catch {
            Write-Host "Request $i failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "Test interrupted by user" -ForegroundColor Yellow
}

Write-Host "`n=== Load Balancing Test Results ===" -ForegroundColor Green
Write-Host "Total requests: $($results.Count)" -ForegroundColor White
Write-Host "Unique containers: $($uniqueContainers.Count)" -ForegroundColor White
Write-Host "`nContainer distribution:" -ForegroundColor White

foreach ($container in $uniqueContainers.GetEnumerator() | Sort-Object Value -Descending) {
    $percentage = [math]::Round(($container.Value / $results.Count) * 100, 1)
    Write-Host "  $($container.Key): $($container.Value) requests ($percentage%)" -ForegroundColor Cyan
}

Write-Host "`nLoad balancing efficiency: $([math]::Round(($uniqueContainers.Count / 3) * 100, 1))%" -ForegroundColor Green
