//////////////////////////////////
// Basic Server
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
// HashiCluster Node (w/Docker)
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
