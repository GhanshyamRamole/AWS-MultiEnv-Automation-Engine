output "stage_ansible_controller_ip" {
  description = "Public IP for the Stage Ansible Controller"
  value       = module.stage_infrastructure.ansible_public_ip
}

output "stage_workload_ips" {
  description = "Private IPs for Stage Swarm/Docker nodes"
  value       = module.stage_infrastructure.workload_ips
}

output "stage_vpc_id" {
  description = "The ID of the Stage VPC"
  value       = module.stage_infrastructure.vpc_id
}
