output "ansible_controller_ip" {
  description = "Public IP for the Dev Ansible Controller"
  value       = module.dev_infrastructure.ansible_public_ip
}

output "dev_workload_ips" {
  description = "Private IPs for Dev Docker/K8s nodes"
  value       = module.dev_infrastructure.workload_ips
}
