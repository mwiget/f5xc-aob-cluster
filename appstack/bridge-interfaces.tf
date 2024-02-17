resource "restapi_object" "bridge_network_interfaces" {
  for_each = var.bridge_vlans
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/network_interfaces"
  data         = jsonencode({
    "metadata": {
      "name": format("%s-%s-%s", var.f5xc_cluster_name, split(".", each.value)[0], split(".", each.value)[1]),
      "description": var.description,
      "disable": false
    },
    "spec": {
      "type": "NETWORK_INTERFACE_LAYER2_INTERFACE",
      "mtu": 0,
      "dhcp_address": "NETWORK_INTERFACE_DHCP_DISABLE",
      "static_addresses": [],
      "DHCP_server": "NETWORK_INTERFACE_DHCP_SERVER_DISABLE",
      "vlan_tagging": "NETWORK_INTERFACE_VLAN_TAGGING_ENABLE",
      "device_name": split(".", each.value)[0],
      "vlan_tag": split(".", each.value)[1],
      "priority": 0,
      "interface_ip_map": {},
      "is_primary": false,
      "layer2_interface": {
        "l2vlan_interface": {
          "device": split(".", each.value)[0]
          "vlan_id": split(".", each.value)[1]
        }
      }
    }
  })
}

output "bridge-network-interfaces" {
  value = restapi_object.bridge_network_interfaces
}

