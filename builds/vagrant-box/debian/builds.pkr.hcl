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
