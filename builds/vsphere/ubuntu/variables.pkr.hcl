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
  default = "pkr-ubuntu"
}

variable "iso_paths" {
  type = set(string)

  default = []
}

variable "admin" {
  description = "Generate encrypted password: echo \"<PASSWORD>\" | mkpasswd -m sha-512 --rounds=4096 -s"

  type = object({
    username           = string
    password           = string
    password_encrypted = string
    ssh_keys           = set(string)
  })

  default = {
    username           = "packer"
    password           = "ubuntu"
    password_encrypted = "$6$rounds=4096$0w1M.g/6$lbLmtUC/yo2XxZIJKlA3LWGuY6GbgY6xF2d1FQLq6xkNoOyfAy.OHSuKkgDRCg6091vP6TScVGtjlsZny32mA1" // ubuntu
    ssh_keys           = []
  }
}

variable "userdata" {
  type = object({
    hostname    = string
    address     = string
    gateway     = string
    nameservers = set(string)
  })
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