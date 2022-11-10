Write-Output "Disabling Automatic WindowsUpdates" -ForegroundColor Cyan
# Disable automatic windows updates
$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if ($RunningAsAdmin) {
  $Updates = (New-Object -ComObject "Microsoft.Update.AutoUpdate").Settings
	
  if ($Updates.ReadOnly -eq $True) {
    Write-Error "Cannot update Windows Update settings due to GPO restrictions."
  }
  
  else {
		$Updates.NotificationLevel = 1 #Disabled
		$Updates.Save()
		$Updates.Refresh()
		
    Write-Output "Automatic Windows Updates disabled."
	}
}