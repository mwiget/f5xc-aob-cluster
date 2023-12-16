output "clusters" {
  value = {
    cluster = module.cluster
  }
  sensitive = false
}
