locals {
  // 2300218: OpenSSH bug
  // 3010: https://docs.chocolatey.org/en-us/choco/commands/install#exit-codes
  exit_codes   = [0, 3010, 2300218]
  os_temp_path = "C:/Windows/Temp"

  consul_version          = "1.13.3"
  nomad_version           = "1.4.2"
  consul_template_version = "0.29.5"
}

//////////////////////////////////
// vSphere Builds
//////////////////////////////////

build {
  sources = [
    "source.vsphere-iso.win2k22",
  ]

  provisioner "windows-restart" {
    pause_before    = "10s"
    restart_timeout = "10m"
  }

  ////////////////////////////////
  // Windows Update
  ////////////////////////////////
  // Usually takes ~15-60 mins (depending on VM resources)
  // Probasbly better to have intermediate build w/only updates

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    valid_exit_codes  = local.exit_codes
    
    script  = join("/", [var.resources_folder, "powershell/Update-Windows.ps1"])
  }

  provisioner "windows-restart" {}

  ////////////////////////////////
  // HashiCorp Applications
  ////////////////////////////////

  provisioner "file" {
    source      = join("/", [var.resources_folder, "powershell/Add-Hashicorp.ps1"])
    destination = join("/", [local.os_temp_path, "Add-Hashicorp.ps1"])
  }

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    valid_exit_codes  = local.exit_codes

    inline = [
      format("powershell.exe '%s'", "${local.os_temp_path}/Add-Hashicorp.ps1 -Name consul -SemVer ${local.consul_version} -HasService $true"),
      format("powershell.exe '%s'", "${local.os_temp_path}/Add-Hashicorp.ps1 -Name nomad -SemVer ${local.nomad_version} -HasService $true"),
      format("powershell.exe '%s'", "${local.os_temp_path}/Add-Hashicorp.ps1 -Name consul-template -SemVer ${local.consul_template_version}"),
    ]
  }

  ////////////////////////////////
  // Chocolatey
  ////////////////////////////////

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    valid_exit_codes  = local.exit_codes

    inline = [join(";", [
      "Set-ExecutionPolicy Bypass -Scope Process -Force",
      "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072",
      "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
    ])]
  }

  provisioner "file" {
    source      = join("/", [var.resources_folder, "chocolatey/server.config"])
    destination = join("/", [local.os_temp_path, "chocolatey.config"])
  }

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password
    valid_exit_codes  = local.exit_codes
    
    inline = [
      "choco install --confirm ${local.os_temp_path}/chocolatey.config",
    ]
  }

  ////////////////////////////////
  // Finalize
  ////////////////////////////////

  provisioner "powershell" {
    valid_exit_codes  = local.exit_codes

    inline = [
      "Set-ItemProperty -Path \"HKCU:\\Control Panel\\International\" -Name sTimeFormat -Value \"HH:mm:ss\"",
      "Set-ItemProperty -Path \"HKCU:\\Control Panel\\International\" -Name sShortTime -Value \"HH:mm\"",
    ]
  }

  provisioner "windows-restart" {}
}
