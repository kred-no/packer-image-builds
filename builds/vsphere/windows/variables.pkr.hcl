//////////////////////////////////
// Static Variables
//////////////////////////////////

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

//////////////////////////////////
// vSphere Credentials
//////////////////////////////////

variable "vcenter_server" {
  type    = string
  default = ""
}

variable "vcenter_insecure" {
  type    = bool
  default = true
}

variable "vcenter_username" {
  type    = string
  default = ""
}

variable "vcenter_password" {
  type    = string
  default = ""
}

//////////////////////////////////
// vSphere Settings
//////////////////////////////////

variable "datacenter_name" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "datastore_name" {
  type    = string
  default = ""
}

variable "network_name" {
  type    = string
  default = ""
}

variable "folder_name" {
  type    = string
  default = ""
}

//////////////////////////////////
// Packer Build Configuration
//////////////////////////////////

variable "vm_name" {
  type    = string
  default = "pkr-windows"
}

variable "iso_installer_path" {
  description = "Windows installer ISO-image."
  type        = string
  default     = ""
}

variable "iso_tools_path" {
  description = "Required if installing VMware Tools from disk."
  type        = string
  default     = "[] /usr/lib/vmware/isoimages/windows.iso"
}

variable "admin" {
  type = object({
    username = string
    password = string
  })

  default = {
    username = "Packer"
    password = "Wind0ws"
  }
}

variable "static_network" {
  type = object({
    address     = string
    netmask     = number
    gateway     = string
    nameservers = set(string)
  })

  default = {
    address     = "192.168.69.0"
    netmask     = 24
    gateway     = "192.168.69.0"
    nameservers = ["1.1.1.1", "8.8.8.8"]
  }
}

variable "resources_folder" {
  type    = string
  default = "./../../resources"
}

variable "convert_to_template" {
  type    = bool
  default = false
}

variable "disable_shutdown" {
  type    = bool
  default = false
}