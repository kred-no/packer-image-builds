# Required Template Variables
# ===========================
# - address     >> string
# - netmask     >> string
# - gateway     >> string
# - nameservers >> list(string)
#
Write-Host "Configuring network" -ForegroundColor Cyan
Get-NetAdapter | Where Status -eq UP | New-NetIPAddress -IPAddress ${address} -PrefixLength ${netmask} -DefaultGateway ${gateway}
Get-NetAdapter | Where Status -eq UP | Set-DnsClientServerAddress -ServerAddresses (${ join(",",formatlist("%q",nameservers)) })
Start-Sleep -Seconds 3