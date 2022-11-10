Write-Output "Installing Microsoft AdminCenter" -ForegroundColor Cyan

${SourceURL} = "https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter2110.2.msi"
${Installer} = ${env:TEMP} + "\WindowsAdminCenter.msi"
Invoke-WebRequest ${SourceURL} -OutFile ${Installer}
Start-Process msiexec.exe -Verb RunAs -Wait -ArgumentList "/i ${Installer} SME_PORT=443 SSL_CERTIFICATE_OPTION=generate /qn"
