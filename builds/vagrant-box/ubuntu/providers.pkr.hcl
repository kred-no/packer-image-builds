packer {

  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = ">= 1.1"
    }

    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1"
    }

    virtualbox = {
      version = ">= 1.0.4"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}