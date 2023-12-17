variable "project_prefix" {
  type        = string
  default     = "f5xc"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_certified_hardware" {
  type = string
  default = "kvm-voltstack-combo"
}

variable "owner" {}

variable "ssh_public_key_file" {
  type = string
}

variable "f5xc_registration_wait_time" {
    type    = number
    default = 60
}

variable "f5xc_registration_retry" {
    type    = number
    default = 20
}

variable "ipmi_user" {
  type = string
  default = ""
}

variable "ipmi_password" {
  type = string
  default = ""
}

variable "target_kickstart_folder" {
  type = string
  default = "."
}

variable "local_http_folder" {
  type = string
  default = "."
}

variable "local_tftp_folder" {
  type = string
  default = "."
}

variable "base_url" {
  type = string
  default = "http://localhost/redhat"
}

variable "admin_password" {
  type = string
  default = ""
}

variable "vesbkp_password" {
  type = string
  default = ""
}
