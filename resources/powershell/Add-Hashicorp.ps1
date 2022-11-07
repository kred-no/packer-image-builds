#Requires -RunAsAdministrator
[cmdletbinding()]
param (
    [Parameter(mandatory=$true)]
    [ValidateSet('nomad','consul','consul-template')]
    [String]$Name,
    [Parameter(mandatory=$true)]
    [String]$SemVer,
    [Boolean]$HasService=$false
)

function Log([String]${Logtext}) {
  ${Timestamp} = (Get-Date -UFormat %T).ToString()
  Write-Output "[${Timestamp}] ${Logtext}"
}

# Define variables
${CName} = (Get-Culture).TextInfo.ToTitleCase(${Name}.ToLower())
${BaseUrl} = 'https://releases.hashicorp.com'
${InstallDir} = "${env:SystemDrive}\\HashiCorp\\${CName}"

${Service} = @{
  Name = "${CName}"
  BinaryPathName = "${InstallDir}\\bin\\${Name}.exe agent -config-dir=${InstallDir}\\config -data-dir=${InstallDir}\\data"
  DisplayName = "${CName}"
  StartupType = "Manual"
  Description = "HashiCorp ${CName} Service."
}

Log "Installing: ${CName} (v${SemVer}) .."

Log "Creating folder .."
if (!(Test-Path ${InstallDir})){
  New-Item -ItemType Directory ${InstallDir}
}
#Set-Location ${InstallDir}
Push-Location ${InstallDir}

Log "Downloading .."
Invoke-WebRequest -Uri "${BaseUrl}/${Name}/${SemVer}/${Name}_${SemVer}_windows_amd64.zip" -Outfile "${InstallDir}\${Name}_${SemVer}_windows_amd64.zip"
Invoke-WebRequest -Uri "${BaseUrl}/${Name}/${SemVer}/${Name}_${SemVer}_SHA256SUMS" -Outfile "${InstallDir}\${Name}_${SemVer}_SHA256SUMS"
Invoke-WebRequest -Uri "${BaseUrl}/${Name}/${SemVer}/${Name}_${SemVer}_SHA256SUMS.sig" -Outfile "${InstallDir}\${Name}_${SemVer}_SHA256SUMS.sig"

Log "Validating .."
Get-Content "${InstallDir}/*SHA256SUMS"| Select-String  (Get-Filehash -algorithm SHA256 "${InstallDir}/${Name}_${SemVer}_windows_amd64.zip").hash.toLower()

Log "Extracting .."
Expand-Archive "${InstallDir}/${Name}_${SemVer}_windows_amd64.zip" "${InstallDir}/bin" -Force

$CurrentEnv = [Environment]::GetEnvironmentVariable('path', 'Machine')
if ("${InstallDir}/bin" -notin $CurrentEnv.Split(";")) {
    Log "Updating active environment path .."
    ${env:path} += ";${InstallDir}/bin"
    [Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path", "Machine") + ";${InstallDir}/bin", "Machine")
}

if ($HasService) {
    if (!(Get-Service -Name ${Service}.Name -ErrorAction SilentlyContinue)){
      Log "Creating service .."
      New-Service @Service
    }
}
#Start-Service -Name ${Service}.Name

Log "Cleaning up .."
Remove-Item -Path "${InstallDir}\${Name}_${SemVer}_windows_amd64.zip"
Remove-Item -Path "${InstallDir}\${Name}_${SemVer}_SHA256SUMS"
Remove-Item -Path "${InstallDir}\${Name}_${SemVer}_SHA256SUMS.sig"
Pop-Location

Log "Done!"
