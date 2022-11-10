Write-Output "Installing OpenSSH-Server"

$TargetCapability = (Get-WindowsCapability -Online -Name "OpenSSH.Server*").Name
Add-WindowsCapability -Online -Name $TargetCapability
Set-Service -Name sshd -StartupType 'Automatic'
Start-Service sshd
Start-Sleep -Seconds 3
