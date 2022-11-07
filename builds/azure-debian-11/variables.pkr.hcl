//////////////////////////////////
// Static Variables
//////////////////////////////////

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

//////////////////////////////////
// Azure Credentials
//////////////////////////////////

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type    = string
  default = ""
}

variable "subscription_id" {
  type    = string
  default = ""
}

variable "tenant_id" {
  type    = string
  default = ""
}

//////////////////////////////////
// Azure Resources
//////////////////////////////////

variable "image_resource_group_name" {
  type    = string
  default = ""
}

variable "build_resource_group_name" {
  type    = string
  default = ""
}

variable "shared_image_gallery" {
  type = object({
    gallery_name        = string
    subscription_id     = string
    resource_group_name = string
  })

  default = null
}

variable "sig_image" {
  type = object({
    name     = string
    version  = string
    replicas = set(string)
  })

  default = null
}

variable "source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }
}

//////////////////////////////////
// Packer Build Configuration
//////////////////////////////////

variable "build_properties" {
  type = object({
    vm_size         = string
    cloud_init_file = string
  })

  default = {
    vm_size         = "Standard_B1ms"
    cloud_init_file = "./../../resources/cloud-init/basic.yaml"
  }
}

variable "resources_folder" {
  type    = string
  default = "./../../resources"
}
