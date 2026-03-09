variable "env" {
  type        = string
  description = "The environment name (e.g., dev, stage, prod)"
}

variable "AWS_REGION" {
  type        = string
  description = "The AWS region to deploy resources in"
}

variable "AWS_AMI" {
  type        = string
  description = "The AMI ID for the instances"
}

variable "az" {
  type        = string
  description = "The availability zone"
}

variable "key" {
  type        = string
  description = "The name of the SSH key pair"
}

variable "passwd" {
  type        = string
  description = "Password for the itadmin user"
  sensitive   = true
}

# --- Instance Count Variables ---
variable "ansible_count" {
  type    = number
  default = 0
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
