////////////////////////
// Variables
////////////////////////

variable "installation_iso" {
  description = "N/A"

  type = object({
    url            = string
    sha256checksum = string
  })

  default = {
    url            = "https://software.download.prss.microsoft.com/dbazure/Win11_23H2_Norwegian_x64v2.iso?t=13185f05-789e-4c50-a697-8d56660f3cc6&P1=1713358372&P2=601&P3=2&P4=sQNoNhxQR3G6fEfqV56zDr5K85peWivEEINYkSaDuukzKCGQWtd0rCcUV5RBntsXv2b4DOvxzcgeTSy%2fvMdft4qVRiWXe6cr6S%2bA%2fL9gHvv3nlmC83XKmRePin4ZWzCm6ymYdg3miDxsX2tnk67Bv05pLMrOG1OHQsKNrfNcNczM%2f08Bx%2bHt6j1ryy9PPhJV0Gxp%2fXfsa3OrqXSwlvwJpwpaKXNviUatznAThFDxz866fiFx0qEc8wHckfS%2bGVYl16DvZEvOYy74uLLCpsRJFM9dIpPQ02DsPfBqfIJZJo5A6chtvBwXAz%2brJur6AnZQRQfk8LervssAq%2fUBm5jLLg%3d%3d"
    sha256checksum = "12DB26712076F29E7509B5B6393F6EF3089D6DECE660F508F7384705D54D608B"
  }
}

variable "headless_build" {
  type    = bool
  default = true
}

////////////////////////
// Authentication
////////////////////////

variable "vagrant_username" {
  description = "N/A"
  type        = string
  default     = "vagrant"
}

variable "vagrant_password" {
  description = "N/A"
  type        = string
  default     = "vagrant"
}

variable "vagrant_password_encrypted" {
  description = "N/A"
  type        = string
  default     = ""
}
