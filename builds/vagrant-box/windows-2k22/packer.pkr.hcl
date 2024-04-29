packer {
  required_version = ">= 1.10"

  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = ">= 1.1"
    }

    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1"
    }
  }
}

