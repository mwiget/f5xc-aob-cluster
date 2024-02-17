resource "restapi_object" "bridge-subnets" {
  depends_on = [ restapi_object.bridge_network_interfaces ]
  for_each = var.bridge_vlans
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/subnets"
  data         = jsonencode({
    "metadata": {
      "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
      "description": var.description,
      "namespace": "system",
      "labels": {},
      "annotations": {},
      "disable": false
    },
    "spec": {
      "site_subnet_params": [
        {
          "site": {
            "namespace": "system",
            "name": var.f5xc_cluster_name,
            "kind": "site"
          },
        }
      ],
      "connect_to_layer2": {
        "layer2_intf_ref": {
          "namespace": "system",
          "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
          "kind": "network_interface"
        },
	"layer2_intf_internal_ref": [
          {
            "kind": "network_interface",
            "namespace": "system",
            "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
          }
        ]
      }
    }
  })
}

#output "bridge-subnets" {
#  value = restapi_object.bridge-subnets
#}

