resource "terraform_data" "pxeboot" {
  for_each   = merge(var.f5xc_master_nodes, var.f5xc_worker_nodes)
  input      = {
    node          = each.key
    ipmi_ip       = length(each.value) > 1 ? each.value["ipmi_ip"] : ""
    ipmi_user     = var.ipmi_user
    ipmi_password = var.ipmi_password
  }

  provisioner "local-exec" {
    command    = "./pxe-boot-node.sh ${self.input.node} ${self.input.ipmi_ip} ${self.input.ipmi_user} ${self.input.ipmi_password}"
  }
  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = "./power-off-node.sh ${self.input.node} ${self.input.ipmi_ip} ${self.input.ipmi_user} ${self.input.ipmi_password}"
  }
}
