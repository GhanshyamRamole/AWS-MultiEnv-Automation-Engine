# --- Ansible Control Plane Outputs ---
output "ansible_public_ip" {
  description = "Public IP of the Ansible Control Node"
  value       = aws_instance.ansible[*].public_ip
}

output "ansible_private_ip" {
  description = "Private IP of the Ansible Control Node"
  value       = aws_instance.ansible[*].private_ip
}

# --- Workload Node Outputs (Docker, K8s, Swarm) ---

output "workload_ips" {
  description = "Map of workload names to their private IP addresses"
  value = {
    for k, v in aws_instance.workloads : k => v.private_ip
  }
}

output "workload_public_ips" {
  description = "Map of workload names to their public IP addresses (if applicable)"
  value = {
    for k, v in aws_instance.workloads : k => v.public_ip
  }
}
 

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id 
}
