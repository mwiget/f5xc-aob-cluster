
output "clusters" {
  value = {
    think = module.think-cluster
    ryzen = module.ryzen-cluster
    hp = module.hp-cluster
  }
  sensitive = false
}

