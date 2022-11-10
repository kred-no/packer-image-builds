//////////////////////////////////
// vSphere Builds
//////////////////////////////////

locals {
  openssh_exit_codes = [0, 2300218]
}

build {
  sources = [
    "source.vsphere-iso.win2k22",
  ]

  provisioner "windows-restart" {
    pause_before    = "15s"
    restart_timeout = "15m"
  }

  provisioner "powershell" {
    elevated_user     = build.User
    elevated_password = build.Password

    valid_exit_codes = local.openssh_exit_codes
    script = join("/", [var.resources_folder, "powershell/Update-Windows.ps1"])
  }

  /*
  post-processors {
    
    post-processor "vsphere-template" {
      host       = local.vcenter_server
      insecure   = local.vcenter_insecure  
      username   = local.vcenter_username
      password   = local.vcenter_password
      datacenter = local.vcenter_datacenter
      folder     = "/_Templates/"
    }
  }*/
}
