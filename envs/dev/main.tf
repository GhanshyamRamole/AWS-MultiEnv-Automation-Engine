module "dev_infrastructure" {
  source = "../../modules"

  env        = var.env
  AWS_REGION = var.AWS_REGION
  AWS_AMI    = var.AWS_AMI
  az         = var.az
  key        = var.key
  passwd     = var.passwd

  ansible_script_path = "modules/scripts/ansible_dev.sh" 
  workloads_script_path = "modules/scripts/ansible_dev.sh" 

  ansible_count      = var.ansible_count
  docker_count       = var.docker_count
  k8s_count          = var.k8s_count
  swarm_master_count = var.swarm_master_count
  swarm_worker_count = var.swarm_worker_count
}
