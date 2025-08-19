# Test API endpoints (PowerShell version)

Write-Host "Testing API endpoints..." -ForegroundColor Green

# Wait for port-forward to be established
Start-Sleep -Seconds 3

Write-Host "1. Testing GET /user endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/user" -Method Get
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n2. Testing POST /user endpoint..." -ForegroundColor Yellow
try {
    $body = @{ name = "Test User $(Get-Date -Format 'HH:mm:ss')" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "http://localhost:8000/user" -Method Post -Body $body -ContentType "application/json"
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n3. Testing GET /container-id endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/container-id" -Method Get
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nAPI testing completed!" -ForegroundColor Green 