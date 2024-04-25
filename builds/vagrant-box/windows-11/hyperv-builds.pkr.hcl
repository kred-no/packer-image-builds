////////////////////////
// Basic Server
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

////////////////////////
// Advanced Server
////////////////////////
// ToDO