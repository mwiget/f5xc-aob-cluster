module "cluster" {
  source                  = "./appstack"
  f5xc_cluster_name       = format("%s-baremetal-3", var.project_prefix)
  description             = format("generated by %s via %s", var.owner, local.terraform_folder)
  local_http_folder       = var.local_http_folder
  local_tftp_folder       = var.local_tftp_folder
  base_url                = var.base_url
  f5xc_master_nodes       = {
    black1  = { net_mac = "3c:ec:ef:43:1c:b2", ipmi_ip = "192.168.42.17" },
    blue1   = { net_mac = "3c:ec:ef:db:08:62", ipmi_ip = "192.168.42.8" },
    green1  = { net_mac = "3c:ec:ef:43:1d:66", ipmi_ip = "192.168.42.7" }
  }
  f5xc_worker_nodes       = {
    #  grey1  = { net_mac = "3c:ec:ef:43:1c:b3" }
  }
  ipmi_user               = var.ipmi_user
  ipmi_password           = var.ipmi_password
  f5xc_tenant             = var.f5xc_tenant
  f5xc_api_url            = var.f5xc_api_url
  f5xc_namespace          = var.f5xc_namespace
  f5xc_api_token          = var.f5xc_api_token
  f5xc_api_ca_cert        = var.f5xc_api_ca_cert
  volterra_certified_hw   = "kvm-voltstack-combo"
  original_outside_nic    = "em1"
  primary_outside_nic     = "eth0"
  owner_tag               = var.owner
  admin_password          = var.admin_password
  vesbkp_password         = var.vesbkp_password
  f5xc_cluster_labels     = { "site-mesh" : format("%s", var.project_prefix) }
  ssh_public_key          = file(var.ssh_public_key_file)
  f5xc_cluster_latitude   = 47.18
  f5xc_cluster_longitude  = 8.47
  kubevirt                = true
  f5xc_tunnel_type        = "SITE_TO_SITE_TUNNEL_SSL"
  # f5xc_http_proxy	      = "http://10.200.2.30:3128"
  # manual_registration     = true  # true -> don't auto-register, terminate
}

