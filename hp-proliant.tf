module "hp-proliant" {
  source                  = "./appstack"
  f5xc_cluster_name       = format("%s-infra-lab-v4", var.project_prefix)
  description             = format("generated by %s via %s", var.owner, local.terraform_folder)
  local_http_folder       = var.local_http_folder
  local_tftp_folder       = var.local_tftp_folder
  base_url                = var.base_url
  f5xc_master_nodes       = {
    sb-hp-4  = { net_mac = "d4:f5:ef:7c:c9:9c", ip = "10.250.0.61/16", ipmi_ip = "192.168.3.5" },
    sb-hp-5  = { net_mac = "d4:f5:ef:7e:65:50", ip = "10.250.0.65/16", ipmi_ip = "192.168.3.4" },
    sb-hp-6  = { net_mac = "d4:f5:ef:7e:66:0c", ip = "10.250.0.68/16", ipmi_ip = "192.168.3.13" }
  }
  f5xc_worker_nodes       = {
    sb-hp-7  = { net_mac = "d4:f5:ef:7c:c9:cc", ip = "10.250.0.14", ipmi_ip = "192.168.3.6" },
    sb-hp-8  = { net_mac = "d4:f5:ef:7c:c9:c8", ip = "10.250.0.15", ipmi_ip = "192.168.3.12" }
  }
  dns_servers             = [ "1.1.1.1", "8.8.8.8" ]
  ip_gateway              = "10.250.0.1"
  ipmi_user               = var.ipmi_user
  ipmi_password           = var.ipmi_password
  f5xc_tenant             = var.f5xc_tenant
  f5xc_api_url            = var.f5xc_api_url
  f5xc_namespace          = var.f5xc_namespace
  f5xc_api_token          = var.f5xc_api_token
  f5xc_api_ca_cert        = var.f5xc_api_ca_cert
  volterra_certified_hw   = "hp-proliant-dl360-voltstack"
  original_outside_nic    = "ens2f0"
  primary_outside_nic     = "ens2f0"
  primary_outside_nic_2   = "ens2f1"
  owner_tag               = var.owner
  admin_password          = var.admin_password
  vesbkp_password         = var.vesbkp_password
  f5xc_cluster_labels     = { "site-mesh" : format("%s", var.project_prefix) }
  ssh_public_key          = file(var.ssh_public_key_file)
  f5xc_cluster_latitude   = 37.3
  f5xc_cluster_longitude  = -122
  kubevirt                = true
  f5xc_tunnel_type        = "SITE_TO_SITE_TUNNEL_SSL"
  kickstart_template      = "kickstart-hp-proliant-dl360.cfg"
  # f5xc_http_proxy	  = "http://10.200.2.30:3128"
  manual_registration     = true  # true -> don't auto-register, terminate
}

