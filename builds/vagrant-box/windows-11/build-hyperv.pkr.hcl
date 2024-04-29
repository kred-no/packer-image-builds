////////////////////////
// Source: Default
////////////////////////

source "hyperv-iso" "w11" {
  headless    = var.headless_build
  skip_export = false

  iso_url      = var.installation_iso.url
  iso_checksum = format("sha256:%s", var.installation_iso.sha256checksum)

  vm_name    = "pkr-win11"
  generation = 2
  cpus       = 2
  memory     = 1024 * 3

  disk_size       = 60 * 1000
  disk_block_size = 8

  enable_secure_boot    = true
  enable_dynamic_memory = true
  guest_additions_mode  = "disable"
  switch_name           = "Default Switch"

  cd_content = {
    "Autounattend.xml" = templatefile("${path.root}/files/templates/Autounattend.xml.tpl", {
      username = var.vagrant_username
      password = var.vagrant_password
    })
  }

  cd_files = [
    "${path.root}/files/scripts/Shutdown.ps1",
  ]

  first_boot_device = "DVD"
  boot_wait         = "1s"

  boot_command = [
    "<up><wait>", "<up><wait>",
    "<up><wait>", "<up><wait>",
  ]

  communicator = "ssh"
  ssh_username = var.vagrant_username
  ssh_password = var.vagrant_password
  ssh_timeout  = "4h"

  #shutdown_command = "cmd.exe /c C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -File E:\\Shutdown.ps1"
  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
}

////////////////////////
// Build: Basic Server
////////////////////////

build {
  name = "WindowsDesktop"
  sources = [
    "source.hyperv-iso.w11",
  ]

  provisioner "breakpoint" {
    disable = true
    note    = "Provisioning"
  }

  # Configure ..

  provisioner "breakpoint" {
    disable = true
    note    = "PostProcessing"
  }

  # See https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant#configuration
  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    architecture        = "amd64"
    include             = []
    output              = "${path.root}/boxes/{{ .BuildName }}-{{ .Provider }}-{{ .Architecture }}-${local.timestamp}.box"
  }
}

