//////////////////////////////////
// Sources: Default Ubuntu
//////////////////////////////////

source "hyperv-iso" "ubuntu" {
  headless = true

  iso_url      = element(var.iso_ubuntu_noble.sources, 0)
  iso_checksum = var.iso_ubuntu_noble.checksum

  generation = 2
  cpus       = 2
  memory     = 2 * 1024

  disk_size       = 10000
  disk_block_size = 8

  enable_secure_boot    = false
  enable_dynamic_memory = true
  guest_additions_mode  = "disable"

  switch_name = "Default Switch"

  http_content = {
    "/meta-data" = ""
    "/user-data" = templatefile("${path.root}/templates/autoinstall.basic.tpl", {
      username = var.packer_user.username
      password = var.packer_user.password_encrypted
    })
  }

  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz",
    "<wait>", " autoinstall",
    #"<wait>", " ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<wait><enter>",
    "<wait>", " ds='nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", "<wait><enter>",
    "initrd /casper/initrd", "<wait><enter>",
    "boot", "<wait><enter>",
  ] // GRUB requires escaping semi-colons OR single-quoting ds-definition !! 'nocloud-net' is also deprecached

  ssh_timeout            = "1h"
  ssh_username           = var.packer_user.username
  ssh_password           = var.packer_user.password
  ssh_port               = 22
  ssh_handshake_attempts = 30

  shutdown_command = format("echo '%s' | sudo -S -E shutdown -P now", var.packer_user.password)
}

//////////////////////////////////
// Build: Basic Ubuntu Server
//////////////////////////////////

build {
  name    = "BasicServer"
  sources = ["sources.hyperv-iso.ubuntu"]

  provisioner "breakpoint" {
    disable = false
    note    = "Finished provisioning .."
  }

  provisioner "shell" {
    name       = "generalize"
    skip_clean = true

    scripts = [
      "${path.root}/scripts/generalize.sh",
    ]
  }

  post-processors {
    post-processor "vagrant" {
      only = [
        "sources.hyperv-iso.ubuntu",
      ]

      keep_input_artifact = false
      compression_level   = 9
      architecture        = "amd64"
      include             = []
      output              = "${path.root}/packer_cache/boxes/{{.BuildName}}-{{.Provider}}-{{.Architecture}}-${local.version}.box"
    }
  }
}

//////////////////////////////////
// Build: HashiCluster Node (w/Docker)
//////////////////////////////////

build {
  name    = "HashiCluster"
  sources = ["sources.hyperv-iso.ubuntu"]

  provisioner "shell" {
    name       = "install"
    skip_clean = true

    scripts = [
      "${path.root}/scripts/hashicluster-docker.sh",
      "${path.root}/scripts/tools.sh",
    ]
  }

  # Stop before shutting down & exporting box
  provisioner "breakpoint" {
    disable = true
    note    = "Finished provisioning .."
  }

  provisioner "shell" {
    name       = "generalize"
    skip_clean = true

    scripts = [
      "${path.root}/scripts/generalize.sh",
    ]
  }

  post-processors {
    post-processor "vagrant" {
      #only = ["hyperv-iso.ubuntu"]
      keep_input_artifact = false
      compression_level   = 9
      architecture        = "amd64"
      include             = []
      output              = "${path.root}/../../../boxes/{{.BuildName}}-{{.Provider}}-{{.Architecture}}-${local.timestamp}.box"
    }
  }
}

//////////////////////////////////
// Build | HashiCluster (w/Podman)
//////////////////////////////////
