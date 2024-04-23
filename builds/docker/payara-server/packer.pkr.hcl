////////////////////////
// Packer Configuration
////////////////////////

packer {
  required_version = ">= 1.10.0"

  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

////////////////////////
// Local Variables
////////////////////////

locals {
  timestamp = formatdate("YYYYMMDD", timestamp())
}
