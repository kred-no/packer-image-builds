# Windows Server

[Microsoft Windows License](https://learn.microsoft.com/nb-no/windows-server/get-started/upgrade-conversion-options#converting-a-current-evaluation-version-to-a-current-retail-version)

```powershell
# Show info
DISM /online /Get-CurrentEdition
DISM /online /Get-TargetEditions

# Activate Windows Server Standard or Datacenter
DISM /online /Set-Edition:<edition ID> /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

# Convert Edition
DISM /online /Set-Edition:ServerDatacenter /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

# Example: DISM /online /Set-Edition:ServerDatacenter /ProductKey:ABCDE-12345-ABCDE-12345-ABCDE /AcceptEula

# Windows Server Essentials /converting between retail, volume-licensed, and OEM licenses
slmgr.vbs /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```
