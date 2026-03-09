variable "env" {}
variable "AWS_REGION" {}
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "subnet_cidr" { default = "10.0.1.0/24" }
variable "AWS_AMI" {}
variable "key" {}
variable "passwd" { sensitive = true }
variable "ansible_script_path" {}
variable "workloads_script_path" {}

variable "azs" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1c"]
}

variable "ansible_count" {
  description = "Number of Ansible control nodes"
  type        = number
  default     = 0
}

variable "docker_count" {
  type    = number
  default = 0
}

variable "k8s_count" {
  type    = number
  default = 0
}

variable "swarm_master_count" {
  type    = number
  default = 0
}

variable "swarm_worker_count" {
  type    = number
  default = 0
}
