////////////////////////
// Basic Server
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

////////////////////////
// Advanced Server
////////////////////////
// ToDO