//////////////////////////////////
// Packer Builds | Windows
//////////////////////////////////

build {
  sources = [
    "source.azure-arm.win2k22",
  ]

  ////////////////////////////////
  // PowerShell Scripts (Elevated)
  ////////////////////////////////

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password

    scripts = [
      join("/", [var.resources_folder, "powershell/Add-AzurePowershell.ps1"]),
      join("/", [var.resources_folder, "powershell/Add-AdminCenter.ps1"]),
    ]
  }

  ////////////////////////////////
  // Inline Scripts (Upload & Run)
  ////////////////////////////////

  provisioner "file" {
    source      = join("/", [var.resources_folder, "powershell/Add-Hashicorp.ps1"])
    destination = "D:/Add-Hashicorp.ps1"
  }

  provisioner "powershell" {
    #elevated_user     = build.User
    #elevated_password = build.Password

    // C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    inline = [
      format("powershell.exe '%s'", "D:/Add-Hashicorp.ps1 -Name consul -SemVer 1.14.0-beta1 -HasService $true"),
      format("powershell.exe '%s'", "D:/Add-Hashicorp.ps1 -Name nomad -SemVer 1.4.2 -HasService $true"),
      format("powershell.exe '%s'", "D:/Add-Hashicorp.ps1 -Name consul-template -SemVer 0.29.5"),
    ]
  }

  ////////////////////////////////
  // Chocolatey
  ////////////////////////////////

  provisioner "powershell" {
    inline = [join(";", [
      "Set-ExecutionPolicy Bypass -Scope Process -Force",
      "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072",
      "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
    ])]
  }

  provisioner "file" {
    source      = join("/", [var.resources_folder, "chocolatey/server.config"])
    destination = "D:/chocolatey.config"
  }

  provisioner "powershell" {
    valid_exit_codes = [0, 3010] # See https://docs.chocolatey.org/en-us/choco/commands/install#exit-codes
    inline           = ["choco install --confirm D:/chocolatey.config"]
  }

  provisioner "windows-restart" {}

  ////////////////////////////////
  // Deprovision
  ////////////////////////////////

  provisioner "powershell" {
    script = join("/", [var.resources_folder, "powershell/Enter-Deprovisioning.ps1"])
  }
}
