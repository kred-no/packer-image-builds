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

# -- Locals

locals {
  timestamp = formatdate("YYYYMMDD", timestamp())
}

# -- Variables

variable "packer_credentials" {
  description = "NOTE: mkpasswd -m sha-512 <PASSWORD>"

  type = object({
    username           = string
    password           = string
    password_encrypted = string
  })

  default = {
    username           = "vagrant"
    password           = "vagrant"
    password_encrypted = "N/A"
  }
}
