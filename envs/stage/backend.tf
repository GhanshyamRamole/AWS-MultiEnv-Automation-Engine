terraform {
  backend "s3" {
    bucket       = "stage-bucket-automation-engine"
    key          = "DevOps/stage/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
    
  }
}
