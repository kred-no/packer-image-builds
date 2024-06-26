Param(
  [Parameter()]
  [switch] $UseStartupWorkaround = $false,
  [Parameter()]
  [string] $Sysprep = "C:\Windows\system32\Sysprep\sysprep.exe"
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

Write-Host "Removing vagrant user"
Remove-LocalUser -Name vagrant

$sysprepUnattend = "E:\Autounattend.generalize.xml"

$sysprepArgs = @(
  "/generalize", "/oobe",
  "/unattend:$SysprepUnattend",
  "/shutdown",
  "/quiet"
)

Write-Host "Invoking sysprep $Sysprep with arguments $sysprepArgs"
Start-Process `
  -Wait `
  -FilePath $Sysprep `
  -ArgumentList $sysprepArgs
