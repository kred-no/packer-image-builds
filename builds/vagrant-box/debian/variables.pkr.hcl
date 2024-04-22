# Locals

locals {
  version = formatdate("YYYYMMDD", timestamp())
}

# Variables

variable "packer_username" {
  type    = string
  default = "vagrant"
}

variable "packer_password" {
  description = "If not using clear-text: mkpasswd -m sha-512 <PASSWORD>"
  type        = string
  default     = "vagrant"
}

variable "root_password" {
  description = "If not using clear-text: mkpasswd -m sha-512 <PASSWORD>"
  type        = string
  default     = "vagrant"
}

variable "bookworm_iso" {
  type = object({
    url          = string
    checksum_url = string
  })

  default = {
    url          = "https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
    checksum_url = "file:https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/SHA256SUMS"
  }
}