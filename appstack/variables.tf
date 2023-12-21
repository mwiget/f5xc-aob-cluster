variable "f5xc_cluster_latitude" {
  type = number
  default = 37
}

variable "description" {
  type = string
  default = ""
}

variable "f5xc_cluster_longitude" {
  type = number
  default = -121
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "volterra_certified_hw" {
  type = string
  default = "kvm-voltstack-combo"
}

variable "ssh_public_key" {
  type = string
  default = ""
}

variable "f5xc_registration_wait_time" {
  type    = number
  default = 60
}

variable "f5xc_registration_retry" {
  type    = number
  default = 20
}

variable "f5xc_cluster_name" {
  type = string
}

variable "f5xc_master_nodes" {
  type = map(map(string))
  default = {
    default = {
      ipmi_ip = ""
      ipmi_user = ""
      ipmi_password = ""
    }
  }
}

variable "f5xc_worker_nodes" {
  type = map(map(string))
  default = {}
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "owner_tag" {}
variable "kubevirt" {
  type = bool
  default = false
}

variable "f5xc_tunnel_type" {
  type    = string
  default = "SITE_TO_SITE_TUNNEL_IPSEC_OR_SSL"
}

variable "f5xc_http_proxy" {
  type    = string
  default = ""
}

variable "http_kickstart_url" {
  type = string
  default = "http://localhost"
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

variable "manual_registration" {
  type = string
  default = false
}

variable "original_outside_nic" {
  type = string
  default = "em1"
}

variable "primary_outside_nic" {
  type = string
  default = "eth0"
}

variable "primary_outside_nic_2" {
  type = string
  default = "eth1"
}

variable "admin_password" {
  type = string
  default = ""
}

variable "vesbkp_password" {
  type = string
  default = ""
}

variable "ipmi_user" {
  type = string
  default = ""
}

variable "ipmi_password" {
  type = string
  default = ""
}

variable "kickstart_template" {
  type = string
  default = "kickstart.cfg"
}

variable "ip_gateway" {
  type = string
  default = ""
}
variable "dns_servers" {
  type = list(string)
  default = []
}
