function Get-StageSentinel {
  Param(
    [Parameter(Mandatory=$true)]
    [string] $Stage
  )

  return "$($env:APPDATA)\SetupFlags\$($Stage)"
}

function Test-StageSentinel {
  Param(
    [Parameter(Mandatory=$true)]
    [string] $Stage
  )

  return !(Test-Path (Get-StageSentinel $Stage))
}

function Write-StageSentinel {
  Param(
    [Parameter(Mandatory=$true)]
    [string] $Stage
  )

  $stageSentinel = Get-StageSentinel $Stage

  $stageSentinelParent = Split-Path -Parent $stageSentinel
  if (!(Test-Path $stageSentinelParent)) {
    New-Item -Type Directory $stageSentinelParent >$null
  }

  New-Item -Type File $stageSentinel >$null
}

function Execute-Stage {
  Param(
    [Parameter(Mandatory=$true)]
    [string] $Stage,

    [Parameter(Mandatory=$true)]
    [ScriptBlock] $ScriptBlock,

    [Parameter(Mandatory=$false)]
    [switch] $ForceComplete
  )

  if (Test-StageSentinel $Stage) {
    if ($ForceComplete) {
      Write-StageSentinel $Stage
    }

    & $ScriptBlock

    Write-StageSentinel $Stage
  }
}

Execute-Stage -Stage "CompletedProfileSetup" -ForceComplete -ScriptBlock {
  Write-BoxstarterMessage "Rebooting system to complete profile setup"
  Invoke-Reboot
}

Execute-Stage -Stage "PreventIdleDisplayTurnOff" -ScriptBlock {
  Write-BoxstarterMessage "Prevent idle display turn off"
  & powercfg -change -monitor-timeout-ac 0
  & powercfg -change -monitor-timeout-dc 0
}

Execute-Stage -Stage "SetPowerShellExecutionPolicy" -ScriptBlock {
  Write-BoxstarterMessage "Setting PowerShell execution policy"
  Update-ExecutionPolicy RemoteSigned
}

Execute-Stage -Stage "SetWindowsUpdatePolicy" -ScriptBlock {
  Write-BoxstarterMessage "Setting update policy"
  Enable-MicrosoftUpdate
  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" `
      -Name AUOptions -PropertyType DWord -Value 1 -Force
}

Execute-Stage -Stage "InstallWindowsUpdates" -ScriptBlock {
  Write-BoxstarterMessage "Installing updates"
  Install-WindowsUpdate -AcceptEula -Criteria "IsHidden=0 and IsInstalled=0"
  if (Test-PendingReboot) {
    Invoke-Reboot
  }
}

# Enable WinRM at the very end of the provisioning process, preventing Packer
# from restarting the machine mid-way through
Execute-Stage -Stage "EnableWinRM" -ScriptBlock {
  Write-BoxstarterMessage "Enabling WinRM"
  Enable-PSRemoting -Force

  Set-Item -Path WSMan:\localhost\MaxTimeoutms             -Value 1800000
  Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value True
  Set-Item -Path WSMan:\localhost\Service\Auth\Basic       -Value True

  Set-Item -Path WSMan:\localhost\Shell\MaxMemoryPerShellMB -Value 2048

  Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
}