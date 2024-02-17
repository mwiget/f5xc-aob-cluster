resource "restapi_object" "subnet-vn-internet" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/subnets"
  data         = local.subnet-vn-internet
}

locals {
  subnet-vn-internet = jsonencode({
    "metadata": {
      "name": format("%s-internet", var.f5xc_cluster_name),
      "description": var.description
      "namespace": "system",
      "labels": {},
      "annotations": {},
      "disable": false
    },
    "spec": {
      "site_subnet_params": [
        {
          "site": {
            "tenant": var.f5xc_tenant,
            "namespace": "system",
            "name": var.f5xc_cluster_name
            "kind": "site"
          },
          "subnet_dhcp_server_params": {
            "dhcp_networks": [
              {
                "network_prefix": "10.40.0.0/24"
              }
            ]
          }
        }
      ],
      "connect_to_slo": {}
    }
  })
}

output "subnet-vn-internet" {
  value = restapi_object.subnet-vn-internet.id
}

