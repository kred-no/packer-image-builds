function Log([String]${logtext}) {
  ${timestamp} = (Get-Date -UFormat %T).ToString()
  Write-Host "[${timestamp}] ${logtext}"
}

Log "Waiting for GA Service (RdAgent) to start."
while ((Get-Service RdAgent).Status -ne 'Running') {
  Start-Sleep -s 5
}

Log "Waiting for GA Service (WindowsAzureGuestAgent) to start."
while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') {
  Start-Sleep -s 5
}

Log "Running Sysprep."
if( Test-Path ${Env:SystemRoot}\system32\Sysprep\unattend.xml ) {
  Remove-Item ${Env:SystemRoot}\system32\Sysprep\unattend.xml -Force
}

& ${Env:SystemRoot}\System32\Sysprep\Sysprep.exe /oobe /generalize /mode:vm /quiet /quit
while(${true}) {
  ${imageState} = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State).ImageState
  
  Log "ImageState: ${imageState}"
  if (${imageState} -eq 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') {
    break
  }
  Start-Sleep -s 5
}

Log "Deprovisioning finished!"
