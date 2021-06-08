
variable "intersight_api_key" {
  type = string
}

variable "intersight_secretkey" {
  type = string
}

variable "intersight_endpoint" {
    type = string
    default = "https://www.intersight.com"
}

variable "vc_password" {
    type = string
}

variable "ssh_user" {
  type = string
  default = "iksadmin"
}

variable "ssh_key" {
    type = string
}