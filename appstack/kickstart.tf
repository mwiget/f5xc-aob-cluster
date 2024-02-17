resource "local_file" "kickstart_files" {
  for_each                 = merge(var.f5xc_master_nodes, var.f5xc_worker_nodes)
  content                  = templatefile("${path.module}/templates/${var.kickstart_template}", {
    cluster_name             = var.f5xc_cluster_name
    host_name                = each.key
    latitude                 = var.f5xc_cluster_latitude
    longitude                = var.f5xc_cluster_longitude
    maurice_private_endpoint = module.maurice.endpoints.maurice_mtls
    maurice_endpoint         = module.maurice.endpoints.maurice
    site_registration_token  = volterra_token.site.id
    ssh_public_key           = chomp(var.ssh_public_key)
    certified_hardware       = var.volterra_certified_hw
    http_proxy               = var.f5xc_http_proxy
    original_outside_nic     = each.value["original_nic"]
    original_outside_nic_2   = var.primary_outside_nic_2 == "" ? "dummy" : each.value["original_nic_2"]
    primary_outside_nic      = var.primary_outside_nic                                                                                                                                          
    primary_outside_nic_2    = var.primary_outside_nic_2
    ip_addr                  = split("/",each.value["ip"])[0]
    ip_prefix                = split("/",each.value["ip"])[1]
    admin_password           = var.admin_password
    vesbkp_password          = var.vesbkp_password
    ip_gateway               = var.ip_gateway
    ip_address               = each.value["ip"]
  })
  filename = format("%s/kickstart/%s.cfg", var.local_http_folder, lower(each.value["net_mac"]))
}

output "kickstart_files" {
  value = format("%s/kickstart/", var.local_http_folder)
}
