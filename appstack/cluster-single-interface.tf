resource "restapi_object" "cluster-single" {
  count = var.primary_outside_nic_2 == "" ? 1 : 0
  id_attribute = "metadata/name"
    path         = "/config/namespaces/system/voltstack_sites"
    data         = jsonencode ({
      "metadata": {
        "name": var.f5xc_cluster_name,
        "namespace": "system",
        "description": var.description,
      },
      "spec": {
        "volterra_certified_hw": var.volterra_certified_hw,
        "master_node_configuration": [ 
          for k,v in var.f5xc_master_nodes: {
            "name": k
          }
        ],
        "worker_nodes": [ for k,v in var.f5xc_worker_nodes : k ],
        "no_bond_devices": {},
        "custom_network_config": {
          "default_config": {},
          "sm_connection_pvt_ip": {},
          "default_interface_config": {},
          "no_network_policy": {},
          "no_forward_proxy": {},
          "global_network_list": {
            "global_network_connections": [
              {
                "slo_to_global_dr": {
                  "global_vn": {
                    "namespace": "system",
                    "name": "sb-ipv6-global-network",
                    "kind": "virtual_network"
                  }
                }
              }
            ]
          },
          "vip_vrrp_mode": "VIP_VRRP_INVALID",
          "tunnel_dead_timeout": 0
        },
        "default_storage_config": {},
        "disable_gpu": {},
        "k8s_cluster": {
          "namespace": "system",
          "name": volterra_k8s_cluster.cluster.name,
          "kind": "k8s_cluster"
        },
        "logs_streaming_disabled": {},
        "allow_all_usb": {},
        var.kubevirt ? "enable_vm" : "disable_vm": {},
        "default_blocked_services": {},
      #  "default_sriov_interface": {},
        "sriov_interfaces": {}
              "sriov_interfaces": {
          "sriov_interface": [
            for pf in var.sriov_interfaces: {
              "interface_name": pf,
              "number_of_vfs": var.number_of_vfs,
              "number_of_vfio_vfs": var.number_of_vfio_vfs
            }
          ]
        }
      }
    })
}
