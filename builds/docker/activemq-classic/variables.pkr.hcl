variable "resource_folder" {
  description = "N/A"
  type        = string
  default     = env("RUNNER_TEMP")
  #default     = env("GITHUB_WORKSPACE")
  #default     = "./../../.."
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
