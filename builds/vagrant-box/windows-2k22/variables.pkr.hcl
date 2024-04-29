////////////////////////
// Local Variables
////////////////////////

locals {
  timestamp             = formatdate("YYYYMMDD", timestamp())
  shared_resources_path = "./../../../resources"
}

////////////////////////
// Build Variables
////////////////////////

variable "headless_build" {
  description = "N/A"
  type        = bool
  default     = false
}

////////////////////////
// Authentication
////////////////////////

variable "packer_credentials" {
  description = "To create Encrypted password (Linux): mkpasswd -m sha-512 <PASSWORD>"

  type = object({
    username           = string
    password           = string
    password_encrypted = string
  })

  default = {
    username           = "vagrant"
    password           = "vagrant"
    password_encrypted = "$6$RPM5oN1dyueHjiVL$V24knK76O08u0dPgZWiiiBafTjV8lfZAErJBmgnaq32QbnrGRvQW4N6a0M5OsZyb/7Lv1c2gLe9LkwaRDQINn0"
  }
}
