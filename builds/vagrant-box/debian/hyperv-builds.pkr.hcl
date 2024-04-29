////////////////////////
// Hyper-V
////////////////////////

source "hyperv-iso" "bookworm" {
  iso_url      = var.bookworm_iso.url
  iso_checksum = var.bookworm_iso.checksum_url

  #iso_target_path  = "${path.root}/packer_cache/iso/"
  output_directory = "${path.root}/packer_cache/hyperv/bookworm"

  skip_export      = false
  headless         = false

  vm_name    = "pkr-bookworm"
  generation = 2
  
  cpus   = 2
  memory = 2048
  
  disk_size       = 10 * 1000
  disk_block_size = 8

  switch_name           = "Default Switch"
  enable_secure_boot    = false
  enable_dynamic_memory = true
  guest_additions_mode  = "disable"

  http_content = {
    "/preseed.cfg" = templatefile("${path.root}/templates/preseed.bookworm.tpl", { var = var })
  }

  boot_wait = "5s"
  boot_command = [
    "c", "<wait>",
    "set root=(cd0)", "<wait><enter>",
    "linux /install.amd/vmlinuz",
    "<wait>", " auto-install/enable=true",
    "<wait>", " debconf/priority=critical",
    "<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg", "<wait><enter>",
    "initrd /install.amd/initrd.gz", "<wait><enter>",
    "boot", "<wait><enter>",
  ] # Finding this command is a PITA. Here we use GRUB cli ..

  ssh_timeout  = "1h"
  ssh_username = var.packer_username
  ssh_password = var.packer_password

  shutdown_command = "echo '${var.packer_username}' | sudo -S shutdown -P now"
}

////////////////////////
// Bookworm Builds
////////////////////////

build {
  sources = [
    "source.hyperv-iso.bookworm",
  ]

  provisioner "breakpoint" {
    disable = false
    note    = "Generalize & Export box"
  }

  # Deprovision
  provisioner "shell" {
    only = ["source.hyperv-iso.bookworm"]
    
    name            = "generalize"
    skip_clean      = true
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} {{ .Path }}"
    
    scripts = [
      "${path.root}/scripts/generalize.sh",
    ]
  }

  post-processors {
    # See https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant/latest/components/post-processor/vagrant#configuration

    post-processor "vagrant" {
      only = ["hyperv-iso.bookworm"]

      keep_input_artifact = false
      compression_level   = 9
      architecture = "amd64"
      include      = []
      output       = "${path.root}/boxes/{{.BuildName}}-{{.Provider}}-{{.Architecture}}-${local.version}.box"
    }
  }
}
