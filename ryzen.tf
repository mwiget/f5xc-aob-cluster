module "ryzen1" {
  source                  = "./appstack"
  f5xc_cluster_name       = format("%s-ryzen1", var.project_prefix)
  description             = format("generated by %s via %s", var.owner, local.terraform_folder)
  local_http_folder       = var.local_http_folder
  local_tftp_folder       = var.local_tftp_folder
  base_url                = var.base_url
  f5xc_master_nodes       = {
    format("%s-green1", var.project_prefix)  = { net_mac = "3c:ec:ef:43:1d:66", ip = "192.168.42.30/24", ipmi_ip = "192.168.42.7",  original_nic = "enp6s0f0" },
    format("%s-blue1",  var.project_prefix)  = { net_mac = "3c:ec:ef:db:08:62", ip = "192.168.42.31/24", ipmi_ip = "192.168.42.8",  original_nic = "enp6s0f0np0" },
    format("%s-black1", var.project_prefix)  = { net_mac = "3c:ec:ef:43:1c:b2", ip = "192.168.42.32/24", ipmi_ip = "192.168.42.17", original_nic = "enp6s0f0np0" }
  }
  f5xc_worker_nodes       = {
    format("%s-milan1", var.project_prefix)  = { net_mac = "b4:96:91:a5:77:b8", ip = "192.168.42.20/24", ipmi_ip = "192.168.42.21", original_nic = "enp129s0f0" }
  }
  ip_gateway              = "192.168.42.1"
  ipmi_user               = var.ipmi_user
  ipmi_password           = var.ipmi_password
  f5xc_tenant             = var.f5xc_tenant
  f5xc_api_url            = var.f5xc_api_url 
  f5xc_namespace          = var.f5xc_namespace
  f5xc_api_token          = var.f5xc_api_token
  f5xc_api_ca_cert        = var.f5xc_api_ca_cert
  volterra_certified_hw   = "kvm-voltstack-combo"
  #volterra_certified_hw   = "kvm-voltstack-combo-gpu"
  primary_outside_nic     = "eth0"
  # primary_outside_nic_2     = "enp4s0f0"
  owner_tag               = var.owner
  admin_password          = var.admin_password
  vesbkp_password         = var.vesbkp_password
  f5xc_cluster_labels     = { "site-mesh" : format("%s", var.project_prefix) }
  ssh_public_key          = file(var.ssh_public_key_file)
  f5xc_cluster_latitude   = 47.18
  f5xc_cluster_longitude  = 8.47
  kubevirt                = true
  f5xc_tunnel_type        = "SITE_TO_SITE_TUNNEL_SSL"
  kickstart_template      = "kickstart-supermicro.cfg"
  # f5xc_http_proxy	      = "http://10.200.2.30:3128"
  manual_registration     = true  # true -> don't auto-register, terminate
  sriov_interfaces        = [
        "enp129s0f1",
        "enp129s0f2",
        "enp194s0f0",
        "enp194s0f1",
        "enp194s0f2",
        "enp194s0f3",
        "enp65s0f0np0",
        "enp65s0f1np1"
  ]
  number_of_vfs         = 64
  number_of_vfio_vfs    = 32
  sriov_vlans           = [
        "enp129s0f1.251",
        "enp129s0f2.251",
        "enp194s0f0.251",
        "enp194s0f1.251",
        "enp194s0f2.251",
        "enp194s0f3.251",
        "enp65s0f0np0.251",
        "enp65s0f1np1.251"
  ]
  bridge_vlans             = [
        "enp129s0f3.251"
  ]
}

output "clusters" {
  value = {
    ryzen1      = module.ryzen1
  }
  sensitive = false
}