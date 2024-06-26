variable "base_image_java_21" {
  description = "N/A"
  type        = string
  default     = "azul/zulu-openjdk-debian:21-jre-headless"
}

variable "payara_version" {
  description = "N/A"
  type        = string
  default     = "6.2024.4"
}

variable "payara_admin_username" {
  description = "N/A"
  type        = string
  default     = "admin"
}

variable "payara_admin_password" {
  description = "N/A"
  type        = string
  default     = "Admin123"
}

variable "activemq_version" {
  description = "N/A"
  type        = string
  default     = "6.1.1"
}

variable "postgres_jdbc_version" {
  description = "N/A"
  type        = string
  default     = "42.7.3"
}

variable "mssql_jdbc_version" {
  description = "N/A"
  type        = string
  default     = "12.6.1"
}

variable "repository" {
  type    = string
  default = "local/payara-server"
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
