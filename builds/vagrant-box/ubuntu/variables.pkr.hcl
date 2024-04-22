// Static Variables

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}


// Build Configuration

variable "vm_name" {
  type    = string
  default = "pkr-ubuntu"
}

variable "packer_user" {
  description = "Generate encrypted password: echo \"<PASSWORD>\" | mkpasswd -m sha-512 --rounds=4096 -s"

  type = object({
    username           = string
    password           = string
    password_encrypted = string
    ssh_keys           = set(string)
  })

  default = {
    username           = "vagrant"
    password           = "vagrant"
    password_encrypted = "$6$5rFpim1KqZfBwzhD$XIwSTmg2rjrzFSX9qcBUs2atswKmwHvMz4RZS8Cmb7gMf5ZmSpcv7q.G3.FW/K5adDoc6BwQSaGxuyBd25gl21"
    ssh_keys           = []
  }
}

variable "disable_shutdown" {
  type    = bool
  default = false
}

variable "iso_ubuntu_jammy" {
  type = object({
    checksum = string
    sources  = list(string)
  })

  default = {
    checksum = "file:http://releases.ubuntu.com/jammy/SHA256SUMS"
    sources = [
      "http://no.releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso",
      "http://ubuntu.uib.no/releases/jammy/ubuntu-22.04.4-live-server-amd64.iso",
      "http://ftp.uninett.no/linux/ubuntu-iso/jammy/ubuntu-22.04.4-live-server-amd64.iso",
    ]
  }
}

variable "iso_ubuntu_noble" {
  type = object({
    checksum = string
    sources  = list(string)
  })

  default = {
    checksum = "file:http://no.releases.ubuntu.com/24.04/SHA256SUMS"
    sources = [
      "http://no.releases.ubuntu.com/24.04/ubuntu-24.04-beta-live-server-amd64.iso",
      "http://ubuntu.uib.no/releases/24.04/ubuntu-24.04-beta-live-server-amd64.iso",
      "http://ftp.uninett.no/linux/ubuntu-iso/24.04/ubuntu-24.04-beta-live-server-amd64.iso",
    ]
  }
}
