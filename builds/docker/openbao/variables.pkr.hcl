variable "base_image" {
  description = "N/A"
  type        = string
  default     = "debian:stable"
}

variable "openbao_version" {
  description = "N/A"
  type        = string
  default     = "2.0.0"
}

variable "build_ui" {
  description = "N/A"
  type        = string
  default     = "yes"
}

variable "golang_version" {
  description = "N/A"
  type        = string
  default     = "1.22.2"
}

variable "target_repository" {
  type    = string
  default = "local/openbao" #env("GITHUB_REPOSITORY")
}

variable "target_registry_server" {
  type    = string
  default = ""
}

variable "target_registry_password" {
  type    = string
  default = ""
}

variable "target_registry_username" {
  type    = string
  default = ""
}
