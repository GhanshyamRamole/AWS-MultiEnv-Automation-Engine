output "prod_ansible_ip" {
  value = module.prod_infrastructure.ansible_public_ip
}

output "eks_cluster_endpoint" {
  value = var.env == "prod" ? module.eks[0].cluster_endpoint : null
}
