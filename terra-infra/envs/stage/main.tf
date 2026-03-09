module "stage_infrastructure" {
  source = "../../modules"

  env        = var.env
  AWS_REGION = var.AWS_REGION
  AWS_AMI    = var.AWS_AMI
  azs        = [var.az, "us-west-1c"]
  key        = var.key
  passwd     = var.passwd

  ansible_script_path = "scripts/ansible_stage.sh"
  workloads_script_path = "scripts/docker.sh"

  ansible_count      = var.ansible_count
  docker_count       = var.docker_count
  k8s_count          = var.k8s_count
  swarm_master_count = var.swarm_master_count
  swarm_worker_count = var.swarm_worker_count
}
