//////////////////////////////////
// Packer Builds | Windows Desktop
//////////////////////////////////

build {
  sources = [
    "source.azure-arm.windows-11",
  ]

  ////////////////////////////////
  // Upload scripts & Run
  ////////////////////////////////

  provisioner "file" {
    destination = "D:/"

    sources = [
      join("/", [var.resources_folder, "powershell/Add-Hashicorp.ps1"])
    ]
  }

  provisioner "powershell" {
    inline = [
      format("powershell.exe '%s'", "D:/Add-Hashicorp.ps1 -Name consul -SemVer 1.14.0-beta1 -HasService $true"),
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
    source      = join("/", [var.resources_folder, "chocolatey/client.config"])
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
