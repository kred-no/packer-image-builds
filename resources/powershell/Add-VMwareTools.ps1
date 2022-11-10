Write-Host "Installing VMware Tools" -ForegroundColor Cyan

Start-Process "E:\setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait
Start-Sleep -Seconds 3