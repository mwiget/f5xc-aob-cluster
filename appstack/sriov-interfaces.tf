resource "restapi_object" "network_interfaces" {
  for_each = var.sriov_vlans
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/network_interfaces"
  data         = split(".", each.value)[1] > 0 ? jsonencode({
    "metadata": {
      "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
      "description": var.description,
      "disable": false
    },
    "spec": {
      "layer2_interface": {
        "l2sriov_interface": {
          "device": split(".", each.value)[0]
          "vlan_id": split(".", each.value)[1]
        }
      }
    }
  }) : jsonencode({
    "metadata": {
      "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
      "description": var.description,
      "disable": false
    },
    "spec": {
      "layer2_interface": {
        "l2sriov_interface": {
          "device": split(".", each.value)[0]
          "untagged": {}
        }
      }
    }
  })
}

output "network-interfaces" {
  value = restapi_object.network_interfaces
}

