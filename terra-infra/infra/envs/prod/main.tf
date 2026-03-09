terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
}

module "prod_infrastructure" {
  source = "../../modules"

  env        = var.env
  AWS_REGION = var.AWS_REGION
  AWS_AMI    = var.AWS_AMI
  azs        = [var.az, "us-west-1c"]
  key        = var.key
  passwd     = var.passwd

  ansible_script_path = "scripts/ansible_prod.sh"
  workloads_script_path = "scripts/cluster.sh" 

  ansible_count      = var.ansible_count
  docker_count       = var.docker_count
  k8s_count          = var.k8s_count
  swarm_master_count = var.swarm_master_count
  swarm_worker_count = var.swarm_worker_count
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  count   = var.env == "prod" ? 1 : 0 

  cluster_name    = "taskapp-cluster"
  cluster_version = "1.31" 
  vpc_id          = module.prod_infrastructure.vpc_id
  subnet_ids      = module.prod_infrastructure.subnet_ids

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2 
      instance_types = ["t2.micro"] 
    }
  }
}
