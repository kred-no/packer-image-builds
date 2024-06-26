////////////////////////
// Source
////////////////////////

source "hyperv-iso" "w2k22" {
  headless    = false
  skip_export = false

  iso_url      = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
  iso_checksum = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325" # Generated


  #firmware              = "efi"

  vm_name    = "packer-w2k22"
  generation = 2
  cpus       = 2
  memory     = 4096

  disk_size       = 40 * 1000
  disk_block_size = 8

  enable_secure_boot    = true
  enable_dynamic_memory = true
  guest_additions_mode  = "disable"
  switch_name           = "Default Switch"

  cd_content = {
    "Autounattend.xml" = templatefile("${path.root}/files/templates/Autounattend.xml.tpl", {
      username = var.packer_credentials.username
      password = var.packer_credentials.password
    })
  }

  cd_files = [
    "${path.root}/files/powershell/shutdown.ps1",
  ]

  first_boot_device = "DVD"
  boot_wait         = "1s"

  boot_command = [
    "<up><wait>", "<up><wait>",
    "<up><wait>", "<up><wait>",
  ]

  communicator = "ssh"
  ssh_username = var.packer_credentials.username
  ssh_password = var.packer_credentials.password
  ssh_timeout  = "4h"

  #shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_command = "cmd.exe /c C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -File E:\\shutdown.ps1"
}

////////////////////////
// Build: Basic Server
////////////////////////

build {
  name    = "WindowsServer"
  sources = ["source.hyperv-iso.w2k22"]

  provisioner "breakpoint" {
    disable = false
    note    = "Before Processing"
  }

  # Install SaltStack

  provisioner "powershell" {
    scripts = [
      "${path.root}/files/powershell/SaltStack.ps1",
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "Post Processing"
  }

  # See https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant#configuration
  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    architecture        = "amd64"
    include             = []
    #vagrantfile_template = "${path.root}/files/templates/vagrant.template"
    output = "${path.root}/boxes/{{ .BuildName }}-{{ .Provider }}-{{ .Architecture }}-${local.timestamp}.box"
  }
}

