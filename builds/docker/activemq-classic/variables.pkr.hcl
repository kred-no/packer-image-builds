variable "resource_folder" {
  description = "N/A"
  type        = string
  #default     = env("RUNNER_TEMP")
  #default     = env("GITHUB_WORKSPACE")
  default     = "./cache"
}

variable "activemq_version" {
  description = "N/A"
  type        = string
  default     = "6.1.2"
}

variable "postgres_jdbc_version" {
  description = "N/A"
  type        = string
  default     = "42.7.3"
}

variable "hawtio_version" {
  description = "N/A"
  type        = string
  default     = "4.0.0"
}

variable "repository" {
  type    = string
  default = "local/activemq" #env("GITHUB_REPOSITORY")
}

variable "registry_server" {
  type    = string
  default = "" #"ghcr.io"
}

variable "registry_password" {
  type    = string
  default = "" #env("GITHUB_TOKEN")
}

variable "registry_username" {
  type    = string
  default = "" #env("GITHUB_ACTOR")
}
