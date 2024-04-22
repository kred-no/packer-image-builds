Param(
  [Parameter()]
  [switch] $UseStartupWorkaround = $false,
)

if ($UseStartupWorkaround) {
  Write-Warning "Cleaning up PowerShell profile workaround for startup items"

  Remove-ItemProperty `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" `
    -Name Shell

  Remove-Item -Force $PROFILE
}

Write-Host "Removing sentinels"
Remove-Item -Force -Recurse "$($env:APPDATA)\SetupFlags"

Write-Host "Logging off users"
Invoke-CimMethod `
  -ComputerName $env:ComputerName `
  -ClassName Win32_Operatingsystem `
  -MethodName Win32Shutdown `
  -Arguments @{ Flags = 4 }

Write-Host "Shutting down computer"
Stop-Computer `
  -ComputerName $env:ComputerName `
  -Force
