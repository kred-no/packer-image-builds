param(
    [Parameter()]
    [switch]$VCUpdate=$true,
    [switch]$GitInstall=$true,
    [String]$Version="3007.0-Py3"
)

$Arch = "AMD64"
if ([IntPtr]::Size -eq 4) {
  $Arch = "x86"
}

# BUG/Workaround: Download VC-Redist
if ($VCUpdate) {
  Push-Location -Path "${env:TEMP}"
  Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile "vc_redist.x64.exe"
  cmd /c "vc_redist.x64.exe /quiet /norestart"
  Remove-Item -Path "vc_redist.x64.exe" -Force
  Pop-Location
}

# Install Git
if ($GitInstall) {
  Push-Location -Path "${env:TEMP}"
  Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-64-bit.exe" -OutFile "Git-64-bit.exe"
  cmd /c "Git-64-bit.exe /VERYSILENT /NORESTART"
  Remove-Item -Path "Git-64-bit.exe" -Force
  Pop-Location
}

# Install SaltStack
$SaltUrl = "https://repo.saltproject.io/salt/py3/windows/latest/Salt-Minion-${Version}-${Arch}-Setup.exe"

Push-Location -Path "${env:TEMP}"
Invoke-WebRequest -Uri ${SaltUrl} -OutFile "Salt-Minion-Setup.exe"
cmd /c "Salt-Minion-Setup.exe /S /start-minion=0"
Remove-Item -Path "Salt-Minion-Setup.exe" -Force
Pop-Location

# Update Package Repo
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

Push-Location -Path "C:\Program Files\Salt Project\Salt"
#cmd /c "salt-pip.exe install pygit2"
cmd /c "salt-call.exe --local winrepo.update_git_repos"
cmd /c "salt-call.exe --local pkg.refresh_db"
Pop-Location

Write-Host "Finished installing SaltStack"