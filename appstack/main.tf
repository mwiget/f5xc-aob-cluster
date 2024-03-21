resource "volterra_token" "site" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

module "maurice" {
  source        = "../modules/utils/maurice"
  f5xc_api_url = var.f5xc_api_url
}

resource "volterra_k8s_cluster" "cluster" {
  name        = var.f5xc_cluster_name
  namespace   = "system"
  description = var.description

  no_cluster_wide_apps              = true
  use_default_cluster_role_bindings = true

  use_default_cluster_roles = true

  cluster_scoped_access_permit = true
  global_access_enable         = true
  no_insecure_registries       = true

  local_access_config {
    local_domain = format("%s.local", var.f5xc_cluster_name)
    default_port = true
  }
  use_default_psp = true
}

#resource "time_sleep" "wait_10_minutes" {
#  depends_on = [restapi_object.cluster]
#  create_duration = "600s"
#}

resource "volterra_registration_approval" "master" {
  depends_on   = [restapi_object.cluster-single, restapi_object.cluster-bond ]
  for_each      = var.manual_registration ? {} : var.f5xc_master_nodes
  cluster_name = var.f5xc_cluster_name
  cluster_size = length(var.f5xc_master_nodes)
  hostname     = each.key
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
  tunnel_type  = var.f5xc_tunnel_type
}

module "site_wait_for_online" {
  count        = var.manual_registration ? 0 : 1
  depends_on     = [restapi_object.cluster-single, restapi_object.cluster-bond ]
  source         = "../modules/f5xc/status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = var.f5xc_cluster_name
  f5xc_tenant    = var.f5xc_tenant
}

resource "volterra_registration_approval" "worker" {
  depends_on   = [module.site_wait_for_online]
  for_each     = var.manual_registration ? {} : var.f5xc_worker_nodes
  cluster_name = var.f5xc_cluster_name
  cluster_size = length(var.f5xc_master_nodes)
  hostname     = each.key
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
  tunnel_type  = var.f5xc_tunnel_type
}

resource "time_offset" "exp_time" {
  offset_days = 90
}

data "http" "kubeconfig" {
  depends_on  = [module.site_wait_for_online]
  url         =  format("%s/web/namespaces/system/sites/%s/global-kubeconfigs", var.f5xc_api_url, var.f5xc_cluster_name)
  method      = "POST"
  request_headers = {
    # "only_once" hack (part 1) to only create it once (subsequent refresh and apply will fail)
    Authorization = fileexists(local.kubeconfig) ? "" : format("APIToken %s", var.f5xc_api_token) 
  }
  request_body = jsonencode({expiration_timestamp: time_offset.exp_time.rfc3339, site: var.f5xc_cluster_name})
}

resource "local_file" "kubeconfig" {
  # "only_once" hack (part 2) to never overwrite it after initial creation
  content  = fileexists(local.kubeconfig) ? file(local.kubeconfig) : data.http.kubeconfig.response_body
  filename = local.kubeconfig
}

