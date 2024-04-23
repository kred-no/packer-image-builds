variable "resource_folder" {
  description = "N/A"
  type        = string
  default     = "."
}

variable "base_image_jre21" {
  description = "N/A"
  type        = string
  default     = "azul/zulu-openjdk-debian:21-jre-headless"
}

variable "payara_version" {
  description = "N/A"
  type        = string
  default     = "6.2024.4"
}

variable "activemq_version" {
  description = "N/A"
  type        = string
  default     = "6.2.1"
}

variable "postgres_jdbc_version" {
  description = "N/A"
  type        = string
  default     = "42.7.3"
}

variable "repository" {
  type    = string
  default = "local/payara-server" #env("GITHUB_REPOSITORY")
}

variable "registry_server" {
  type    = string
  default = ""
}

variable "registry_password" {
  type    = string
  default = ""
}

variable "registry_username" {
  type    = string
  default = ""
}

variable "registry_login" {
  type    = string
  default = true
}
