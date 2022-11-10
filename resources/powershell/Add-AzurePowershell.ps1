# See https://learn.microsoft.com/en-us/powershell/azure/install-az-ps
Write-Output "Installing Azure CLI Tools"

${ReleaseVersion} = "9.1.0"
${ReleaseId} = "36571"
${ReleaseDate} = "November2022"
${DownloadUrl} = "https://github.com/Azure/azure-powershell/releases/download/v${ReleaseVersion}-${ReleaseDate}/Az-Cmdlets-${ReleaseVersion}.${ReleaseId}-x64.msi"
${ErrorActionPreference} = "Stop"
${OutFile} = "D:\az-pwsh.msi" # temporary disk

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri ${DownloadUrl} -OutFile ${OutFile}
Start-Process "msiexec.exe" -Wait -ArgumentList "/package ${OutFile}"
Start-Sleep -Seconds 3
