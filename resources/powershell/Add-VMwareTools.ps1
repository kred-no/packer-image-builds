Write-Output "Installing VMware Tools"

Start-Process "E:\setup64.exe" -ArgumentList '/s /v "/qb REBOOT=R"' -Wait
Start-Sleep -Seconds 3
