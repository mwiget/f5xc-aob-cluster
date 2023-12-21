output "clusters" {
  value = {
    supermicro  = module.supermicro
    hp-proliant = module.hp-proliant
    kvm         = module.kvm
  }
  sensitive = false
}
